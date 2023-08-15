//
//  AllReviewsViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 03/08/23.
//

import UIKit

class AllReviewsViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case Header = 0
        case Reviews = 1
    }
    
    static let identifier = "AllReviewsViewController"
    
    @IBOutlet private weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    private func registerCells() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ReviewsHeaderTableViewCell.nib, forCellReuseIdentifier: ReviewsHeaderTableViewCell.identifier)
        tableView.register(ReviewTableViewCell.nib, forCellReuseIdentifier: ReviewTableViewCell.identifier)
    }
    
    private let viewModel = AllReviewsViewModel()

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func configure(productId: Int, reviews: ProductReviews) {
        viewModel.configure(productId: productId, reviews: reviews)
    }
}

// MARK: - UITableView DataSource & Delegate

extension AllReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.Header.rawValue:
            return 1
        case Section.Reviews.rawValue:
            return viewModel.reviewsCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.Header.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsHeaderTableViewCell.identifier) as? ReviewsHeaderTableViewCell else {
                print("Failed to dequeue ReviewsHeaderTableViewCell")
                return UITableViewCell()
            }
            cell.configure(reviewsCount: viewModel.reviewsCount, reviewsAverage: viewModel.productReviews.ratingAverage)
            cell.delegate = self
            return cell
        case Section.Reviews.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier) as? ReviewTableViewCell else {
                print("Failed to dequeue ReviewTableViewCell")
                return UITableViewCell()
            }
            if let review = viewModel.getReviewAtIndex(index: indexPath.row) {
                cell.configureReview(model: review)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - ReviewsHeaderTableViewCellDelegate

extension AllReviewsViewController: ReviewsHeaderTableViewCellDelegate {
    
    func addReviewButtonPressed() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddReviewViewController.identifier) as? AddReviewViewController else { return }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - AddReviewViewControllerDelegate

extension AllReviewsViewController: AddReviewViewControllerDelegate {
    
    func onSubmitReviewDone() {
        SnackBarDanger.make(in: self.view, message: "Review submitted", duration: .lengthShort).show()
    }
}
