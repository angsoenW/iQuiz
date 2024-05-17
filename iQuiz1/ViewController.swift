//
//  ViewController.swift
//  iQuiz1
//
//  Created by Jasper Wang on 5/16/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBAction func settings(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Settings go here", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
    }
    
    var quizzes: [Quiz] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(QuizTableViewCell.self, forCellReuseIdentifier: "QuizCell")
        tblView.dataSource = self
        tblView.delegate = self
        tblView.rowHeight = UITableView.automaticDimension
        
        if UserDefaults.standard.bool(forKey: "Switch") {
            if (UserDefaults.standard.string(forKey: "URL") != nil) {
                fetchQuizzes(urlString: UserDefaults.standard.string(forKey: "URL")!)
            } else {
                fetchQuizzes(urlString: "http://tednewardsandbox.site44.com/questions.json")
            }
        } else {
            setupQuizzes()
        }
        
        setupRefreshControl()
        printQuizzes()

    }
    
    func setupQuizzes() {
        let scienceQuestions = [
            Question(text: "What is a black hole?", answer: "2", answers: [
                "A large mass of dark matter",
                "A region of space where gravity is so strong that nothing, not even light, can escape",
                "A star that has run out of fuel",
                "A hypothetical tunnel connecting different parts of the universe"
            ])
        ]

        let marvelQuestions = [
            Question(text: "Who is Captain America's arch-nemesis?", answer: "2", answers: [
                "Loki",
                "Red Skull",
                "Thanos",
                "Ultron"
            ]),
            Question(text: "What is the real name of Black Panther?", answer: "1", answers: [
                "T'Challa",
                "M'Baku",
                "Erik Killmonger",
                "Shuri"
            ]),
            Question(text: "How did Wolverine get his adamantium skeleton?", answer: "2", answers: [
                "He was born with it",
                "He underwent an experimental procedure by Weapon X",
                "He absorbed it from another mutant",
                "He found it during a mission"
            ])
        ]

        let mathQuestions = [
            Question(text: "What is the value of Pi to two decimal places?", answer: "1", answers: [
                "3.14",
                "3.41",
                "2.14",
                "3.04"
            ]),
            Question(text: "What is the square root of 16?", answer: "1", answers: [
                "4",
                "8",
                "2",
                "6"
            ]),
            Question(text: "What is the derivative of x^2 with respect to x?", answer: "1", answers: [
                "2x",
                "x^2",
                "1",
                "2"
            ])
        ]

        let scienceQuiz = Quiz(title: "Science!", desc: "Exploring the wonders of science.", questions: scienceQuestions, imgName: "science")
        let marvelQuiz = Quiz(title: "Marvel Super Heroes", desc: "Avengers, Assemble!", questions: marvelQuestions, imgName: "Marvel")
        let mathQuiz = Quiz(title: "Mathematics", desc: "Sharpen your math skills!", questions: mathQuestions, imgName: "Mathematics")

        quizzes = [scienceQuiz, marvelQuiz, mathQuiz]

    }

    func fetchQuizzes(urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                self.quizzes = quizzes
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
        
        task.resume()
    }

    func printQuizzes() {
        for quiz in quizzes {
            print("Quiz Title: \(quiz.title), Description: \(quiz.desc)")
            for question in quiz.questions {
                print("Question: \(question.text)")
                print("Answers: \(question.answers)")
                print("Correct Answer Index: \(question.answer)")
            }
        }
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        tblView.addSubview(refreshControl)
    }
    
    @objc func reload() {
        if UserDefaults.standard.bool(forKey: "Switch") {
            if (UserDefaults.standard.string(forKey: "URL") != nil) {
                fetchQuizzes(urlString: UserDefaults.standard.string(forKey: "URL")!)
            } else {
                fetchQuizzes(urlString: "http://tednewardsandbox.site44.com/questions.json")
            }
        } else {
            setupQuizzes()
        }
        tblView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

class Question: Codable {
    var text: String
    var answer: String
    var answers: [String]

    init(text: String, answer: String, answers: [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
}

class Quiz: Codable {
    var title: String
    var desc: String
    var questions: [Question]
    var imgName: String?

    init(title: String, desc: String, questions: [Question], imgName: String?) {
        self.title = title
        self.desc = desc
        self.questions = questions
        self.imgName = imgName ?? ""
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as? QuizTableViewCell else {
            return UITableViewCell()
        }

        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        cell.delegate = self  // Set the delegate
        return cell
    }
}

extension ViewController: QuizTableViewCellDelegate {
    func didSelectQuiz(_ quiz: Quiz) {
        let questionVC = QuestionViewController()
        questionVC.quiz = quiz
        navigationController?.pushViewController(questionVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedQuiz = quizzes[indexPath.row]
        
        // Navigate to the QuestionViewController
        let questionVC = QuestionViewController()
        questionVC.quiz = selectedQuiz
        navigationController?.pushViewController(questionVC, animated: true)
    }
}
