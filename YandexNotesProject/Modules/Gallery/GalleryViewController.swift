//
//  GalleryViewController.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 21/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let imagePickerController = UIImagePickerController()

    var gallery = ImagesLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(mediaLibraryAlert))
        
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.allowsEditing = true
    }

    func add(_ image: UIImage) {
        gallery.add(image)
        closeImagePicker()
        collectionView.performBatchUpdates({
            [unowned self] () -> Void in
            let indexPath = IndexPath(item: self.gallery.count() - 1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
            }, completion: nil)
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) {
            [unowned self] _ in
            self.imagePickerController.sourceType = type
            self.present(self.imagePickerController, animated: true)
        }
    }

    @objc func mediaLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = action(for: .photoLibrary, title: "Альбомы") {
            alertController.addAction(action)
        }
        
        
        if let action = action(for: .savedPhotosAlbum, title: "Последние фотографии") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "slideGallery",
            let controller = segue.destination as? DetailsGalleryViewController,
            let selectedCellPaths = collectionView.indexPathsForSelectedItems,
            let cellIndex = selectedCellPaths.first {
            controller.currentImageIndex = cellIndex.item
            controller.gallery = gallery

            collectionView.deselectItem(at: cellIndex, animated: false)
        }
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! GalleryCollectionViewCell
        
        let image = gallery[indexPath.item]

        cell.imageView.image = image
        cell.imageView.contentMode = .scaleAspectFill
        
        cell.imageView.applyShadowWithCorner(containerView: cell.shadowView, cornerRadious: 5.0)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "slideGallery", sender: nil)
    }
}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func closeImagePicker() {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        closeImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            closeImagePicker()
            return
        }
        add(image)
    }
}
