//
//  QuestionViewController.swift
//  iQuiz1
//
//  Created by Jasper Wang on 5/16/24.
//

import UIKit

class QuestionViewController: UIViewController {

    var quiz: Quiz!
    var currentQuestionIndex = 0
    var correctAnswers = 0
    var selectedAnswerIndex: Int?
    
    let questionLabel = UILabel()
    let answersStackView = UIStackView()
    let submitButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(submitAnswer))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backToTopics))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        setupViews()
        displayQuestion()
    }
    
    func setupViews() {
        questionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answersStackView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(questionLabel)
        view.addSubview(answersStackView)
        view.addSubview(submitButton)
        
        questionLabel.font = UIFont.systemFont(ofSize: 24)
        questionLabel.numberOfLines = 0
        
        answersStackView.axis = .vertical
        answersStackView.spacing = 10
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            answersStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            answersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: answersStackView.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(submitAnswer)), animated: true)
    }
    
    func displayQuestion() {
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        
        answersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, answer) in question.answers.enumerated() {
            let button = UIButton(type: .system)
            button.titleLabel?.numberOfLines = 0
            //button.titleLabel?.textAlignment = .center
            button.setTitle(answer, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchUpInside)
            answersStackView.addArrangedSubview(button)
        }
    }
    
    @objc func selectAnswer(_ sender: UIButton) {
        selectedAnswerIndex = sender.tag
        for button in answersStackView.arrangedSubviews as! [UIButton] {
            button.isSelected = button == sender
        }
    }
    
    @objc func submitAnswer() {
        guard let selectedAnswerIndex = selectedAnswerIndex else {
            let alert = UIAlertController(title: "Error", message: "Please select an answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if the answer is correct
        if selectedAnswerIndex == Int(quiz.questions[currentQuestionIndex].answer)! - 1 {
            correctAnswers += 1
        }
        
        let answerVC = AnswerViewController()
        answerVC.quiz = quiz
        answerVC.currentQuestionIndex = currentQuestionIndex
        answerVC.selectedAnswerIndex = selectedAnswerIndex
        answerVC.correctAnswers = correctAnswers
        navigationController?.pushViewController(answerVC, animated: true)
    }
    
    @objc func backToTopics() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
