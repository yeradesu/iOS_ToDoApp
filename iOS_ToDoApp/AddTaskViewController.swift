import UIKit

class AddTaskViewController: UIViewController {
    
    var onTaskAdded: ((AddTask) -> Void)? // closure
    
    // properties with imediate configurations. idk how to comment that diffently
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.items = [UINavigationItem()]
        bar.items?.first?.leftBarButtonItem = UIBarButtonItem(title: "Discard", style: .plain, target: self, action: #selector(discardAction))
        bar.items?.first?.leftBarButtonItem?.tintColor = .red
        bar.items?.first?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        return bar
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 223.0/255, green: 223.0/255, blue: 223.0/255, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = false
        textView.isEditable = true
        return textView
    }()
    
    let itemsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 223.0/255, green: 223.0/255, blue: 223.0/255, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = false
        textView.isEditable = true
        return textView
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    // MARK: -PRIVATE FUNCTIONS
    private func setupViews() {
        view.addSubview(navigationBar)
        view.addSubview(titleTextView)
        view.addSubview(itemsTextView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleTextView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextView.heightAnchor.constraint(equalToConstant: 38),
            
            itemsTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20),
            itemsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemsTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }
    
    @objc private func discardAction() {
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func saveAction() {
        let title = titleTextView.text!
        let detail = itemsTextView.text!
        
        let updatedTask = AddTask(taskTitle: title, taskDetail: detail)
        
        if !updatedTask.taskTitle.isEmpty || !updatedTask.taskDetail.isEmpty {
            onTaskAdded?(updatedTask)
        }
        
        titleTextView.text = ""
        itemsTextView.text = ""
        
        dismiss(animated: true)
    }
}
