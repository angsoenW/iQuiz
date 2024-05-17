//
//  FinishedViewController.swift
//  iQuiz1
//
//  Created by Jasper Wang on 5/16/24.
//

import UIKit

class FinishedViewController: UIViewController {

    var quiz: Quiz!
    var correctAnswers: Int!
    
    let resultLabel = UILabel()
    let scoreLabel = UILabel()
    let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        displayResults()
    }
    
    func setupViews() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(resultLabel)
        view.addSubview(scoreLabel)
        view.addSubview(nextButton)
        
        resultLabel.font = UIFont.systemFont(ofSize: 24)
        resultLabel.numberOfLines = 0
        
        scoreLabel.font = UIFont.systemFont(ofSize: 18)
        
        nextButton.setTitle("Back to Topics", for: .normal)
        nextButton.addTarget(self, action: #selector(backToTopics), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func displayResults() {
        // Calculate the score
        let totalQuestions = quiz.questions.count
        scoreLabel.text = "Your score: \(correctAnswers!) out of \(totalQuestions)"
        
        // Display a result message based on performance
        if correctAnswers == totalQuestions {
            resultLabel.text = "Perfect!"
        } else if correctAnswers >= totalQuestions / 2 {
            resultLabel.text = "Almost!"
        } else {
            resultLabel.text = "Better luck next time!"
        }
    }
    
    @objc func backToTopics() {
        navigationController?.popToRootViewController(animated: true)
    }
}
