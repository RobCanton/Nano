//
//  CreateProfileVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-04.
//

import Foundation
import UIKit
import Photos
import Firebase

protocol CreateProfileDelegate:class {
    func createProfileDidComplete()
}

class CreateProfileViewController: UIViewController {
    
    weak var delegate:CreateProfileDelegate?
    
    var isPopup:Bool
    init(isPopup:Bool = false) {
        self.isPopup = isPopup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var selectedImage:UIImage? {
        didSet {
            self.profileImageView.image = selectedImage
            self.profileIconView.isHidden = selectedImage != nil
            self.validateForm()
        }
    }
    
    var username:String? {
        didSet {
            print("qwewqwe")
            self.validateForm()
        }
    }
    
    var profileImageView:UIImageView!
    var profileIconView:UIImageView!
    var tableView:UITableView!
    
    var doneButton:UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        navigationItem.title = "Create Profile"
        
        if isPopup {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(handleClose))
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 96 + 32))
        //headerView.backgroundColor = UIColor.blue
        
        profileImageView = UIImageView()
        headerView.addSubview(profileImageView)
        profileImageView.constraintWidth(to: 96)
        profileImageView.constraintHeight(to: 96)
        profileImageView.constraintToCenter(axis: [.x, .y])
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.cornerRadius = 96/2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.systemFill
        profileImageView.contentMode = .scaleAspectFill
        
        profileIconView = UIImageView()
        profileIconView.image = UIImage(systemName: "camera.fill")
        profileIconView.tintColor = UIColor.label
        profileIconView.contentMode = .scaleAspectFit
        profileIconView.alpha = 0.25
        profileImageView.addSubview(profileIconView)
        profileIconView.constraintWidth(to: 32)
        profileIconView.constraintHeight(to: 32)
        profileIconView.constraintToCenter(axis: [.x,.y])
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.tableHeaderView = headerView
        tableView.register(EditUsernameCell.self, forCellReuseIdentifier: "usernameCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleClose))
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        doneButton.isEnabled = false
        doneButton.tintColor = Theme.current.primary
        navigationItem.rightBarButtonItem = doneButton
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoButton))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditUsernameCell
        
        if let profile = UserManager.shared.userProfile {
            profileIconView.isHidden = true
            ImageManager.downloadImage(from: profile.profileImageURL) { url, source, image in
                self.profileImageView.image = image
            }
            cell?.textField.text = profile.username
        } else {
            profileIconView.isHidden = false
            cell?.textField.becomeFirstResponder()
        }
        
        
    }
    
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePhotoButton() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        self.present(pickerController, animated: true, completion: nil)
     
    }
    
    @objc func textFieldDidChange(_ textField:UITextField) {
        if let text = textField.text, !text.isEmpty {
            username = text
        } else {
            username = nil
        }
    }
    
    func validateForm() {
            
        if let username = self.username,
            username.count >= 5,
            let profileImage = self.selectedImage {
            self.doneButton.isEnabled = true
        } else {
            self.doneButton.isEnabled = false
        }
        
    }
    
    @objc func handleSave() {
        guard let username = username else { return }
        guard let profileImage = selectedImage else { return }
        doneButton.isEnabled = false
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        uploadProfileImage(profileImage) { url in
            if let url = url {
                self.saveProfile(username: username, profileImageURL: url) { saveProfileSuccess in
                    if saveProfileSuccess {
                        self.delegate?.createProfileDidComplete()
                        
                        if self.isPopup {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    } else {
                        // handle fail
                    }
                }
            } else {
                // handle fail
            }
        }
            
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping (_ url:URL?)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storage = Storage.storage()
        let imageRef = storage.reference(withPath: "user/profile/\(uid).jpg")
        
        // Local file you want to upload
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        print("Upload starting")
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = imageRef.putData(imageData)

        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
          // Upload resumed, also fires when the upload starts
        }

        uploadTask.observe(.pause) { snapshot in
          // Upload paused
        }

        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
          //let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            /// Double(snapshot.progress!.totalUnitCount)
        }

        uploadTask.observe(.success) { snapshot in
          // Upload completed successfully
            print("Upload success!: \(snapshot)")
            imageRef.downloadURL { url, _ in
                completion(url)
            }
            
        }

        uploadTask.observe(.failure) { snapshot in
          if let error = snapshot.error as? NSError {
            print("Error: \(error.localizedDescription)")
            completion(nil)
            switch (StorageErrorCode(rawValue: error.code)!) {
            case .objectNotFound:
              // File doesn't exist
              break
            case .unauthorized:
              // User doesn't have permission to access file
              break
            case .cancelled:
              // User canceled the upload
              break

            /* ... */

            case .unknown:
              // Unknown error occurred, inspect the server response
              break
            default:
              // A separate error occurred. This is a good place to retry the upload.
              break
            }
          }
        }
    }
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping (_ success:Bool)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let firestore = Firestore.firestore()
        let doc = firestore.collection("userProfiles").document(uid)
        
        let data = [
            "username": username,
            "profileImageURL": profileImageURL.absoluteString
        ]
        
        doc.setData(data) { error in
            if let error = error {
                completion(false)
            } else {
                UserManager.shared.fetchUserProfile {
                    completion(true)
                }
            }
        }
        
    }
}

extension CreateProfileViewController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //self.pickerController(picker, didSelect: nil)
        picker.dismiss(animated: true, completion: nil)
        
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        self.selectedImage = image
    }
}

extension CreateProfileViewController: UINavigationControllerDelegate {

}

extension CreateProfileViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Must be 6 or more characters."
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usernameCell", for: indexPath) as! EditUsernameCell
        cell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return cell
    }
}
