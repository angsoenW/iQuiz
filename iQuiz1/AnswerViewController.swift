//
//  AnswerViewController.swift
//  iQuiz1
//
//  Created by Jasper Wang on 5/16/24.
//

import UIKit

class AnswerViewController: UIViewController {

    var quiz: Quiz!
    var currentQuestionIndex: Int!
    var selectedAnswerIndex: Int!
    var correctAnswers: Int!
    
    let questionLabel = UILabel()
    let correctAnswerLabel = UILabel()
    let feedbackLabel = UILabel()
    let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextQuestion))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backToTopics))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        setupViews()
        displayAnswer()
    }
    
    func setupViews() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        correctAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(questionLabel)
        view.addSubview(correctAnswerLabel)
        view.addSubview(feedbackLabel)
        view.addSubview(nextButton)
        
        questionLabel.font = UIFont.systemFont(ofSize: 24)
        questionLabel.numberOfLines = 0
        
        correctAnswerLabel.font = UIFont.systemFont(ofSize: 18)
        correctAnswerLabel.textColor = .green
        
        feedbackLabel.font = UIFont.systemFont(ofSize: 18)
        feedbackLabel.textColor = .red
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            correctAnswerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            correctAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            correctAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            feedbackLabel.topAnchor.constraint(equalTo: correctAnswerLabel.bottomAnchor, constant: 10),
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextQuestion)), animated: true)
        
    }
    
    func displayAnswer() {
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        correctAnswerLabel.text = "Correct Answer: \(question.answers[Int(question.answer)! - 1])"
        
        if selectedAnswerIndex == Int(question.answer)! - 1 {
            feedbackLabel.text = "You got it right!"
        } else {
            feedbackLabel.text = "Sorry, that's not correct."
        }
    }
    
    @objc func nextQuestion() {
        if currentQuestionIndex < quiz.questions.count - 1 {
            let questionVC = QuestionViewController()
            questionVC.quiz = quiz
            questionVC.currentQuestionIndex = currentQuestionIndex + 1
            questionVC.correctAnswers = correctAnswers
            navigationController?.pushViewController(questionVC, animated: true)
        } else {
            let finishedVC = FinishedViewController()
            finishedVC.quiz = quiz
            finishedVC.correctAnswers = correctAnswers
            navigationController?.pushViewController(finishedVC, animated: true)
        }
    }
    
    @objc func backToTopics() {
        navigationController?.popToRootViewController(animated: true)
    }
}

