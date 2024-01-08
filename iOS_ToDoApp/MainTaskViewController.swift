import UIKit

class MainTaskViewController: UIViewController {
    
    //MARK: - UI PROPERTIES
    var tableView =         UITableView()
    var titleLabel =        UILabel()
    var separatorView =     UIView()
    var addTaskButton =     UIButton()
    var editTaskButton =    UIButton()
    var infoLabel =         UILabel()
    
    // MARK: PROPERTY
    var tasks: [AddTask] = []

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupButtonActions()
        loadTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadius()
    }
    
    // MARK: - PUBLIC FUNCTIONS
    func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: "tasks")
        }
    }

   func loadTasks() {
        if let savedTasks = UserDefaults.standard.object(forKey: "tasks") as? Data {
            if let decodedTasks = try? JSONDecoder().decode([AddTask].self, from: savedTasks) {
                tasks = decodedTasks
            }
        }
   }
    
    func toggleCheckmark(at indexPath: IndexPath) {
        tasks[indexPath.row].isChecked.toggle() // переключает состояние
        saveTasks() // сохраняет обновленный массив
        tableView.reloadRows(at: [indexPath], with: .automatic) // обновляет ячейку
    }
    
    // MARK: PRIVATE FUNCTION
    private func configureUI() {
        view.backgroundColor = .white
        configureButtons()
        
        // configuring the label
        view.addSubview(titleLabel)
        
        titleLabel.text = "ToDoApp"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        // top separator for tableView
        view.addSubview(separatorView)
        separatorView.backgroundColor = tableView.separatorColor
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.2).isActive = true
        
        settingTableView()
        configureTableViewFooter()
    }
    
    private func settingTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 64
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: editTaskButton.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureTableViewFooter() {
        infoLabel.textAlignment = .center
        infoLabel.text = "Push + button to add a new task to the list."
        infoLabel.textColor = .lightGray
        infoLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)

        tableView.tableFooterView = infoLabel
    }
    
    private func configureButtons() {
        view.addSubview(addTaskButton)
        view.addSubview(editTaskButton)
        addTaskButton.backgroundColor = .systemGreen
        editTaskButton.backgroundColor = .systemBlue

        let largeConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)

        if let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(largeConfiguration) {
            addTaskButton.setImage(plusImage, for: .normal)
        }

        if let pencilImage = UIImage(systemName: "pencil")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(largeConfiguration) {
            editTaskButton.setImage(pencilImage, for: .normal)
        }

        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        editTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTaskButton.widthAnchor.constraint(equalToConstant: 65),
            addTaskButton.heightAnchor.constraint(equalToConstant: 65),

            editTaskButton.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -25),
            editTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editTaskButton.widthAnchor.constraint(equalToConstant: 65),
            editTaskButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func setCornerRadius() {
        addTaskButton.layer.cornerRadius = addTaskButton.frame.width / 2
        editTaskButton.layer.cornerRadius = editTaskButton.frame.width / 2
    }
    
    private func setupButtonActions() {
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        editTaskButton.addTarget(self, action: #selector(editTask), for: .touchUpInside)
    }
    
    @objc private func addTask() {
        let vc = AddTaskViewController()
        vc.onTaskAdded = { [weak self] newTask in
                self?.tasks.append(newTask)
                self?.tableView.reloadData()
        }
        saveTasks()
        self.present(vc, animated: true)
    }
    
    @objc private func editTask() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if addTaskButton.isEnabled == true {
            addTaskButton.isEnabled = false
        } else {
            addTaskButton.isEnabled = true
        }
        saveTasks()
    }
    
    private func pressEditTask(at indexPath: IndexPath) {
        let taskToEdit = tasks[indexPath.row]
        let editVC = AddTaskViewController()
        editVC.titleTextView.text = taskToEdit.taskTitle
        editVC.itemsTextView.text = taskToEdit.taskDetail
        editVC.onTaskAdded = { [weak self] updatedTask in
            self?.tasks[indexPath.row] = updatedTask
            self?.saveTasks()
            self?.tableView.reloadData()
        }
        present(editVC, animated: true)
    }
}

// MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension MainTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleCheckmark(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        let task = tasks[indexPath.row]
        cell.configureWithTask(task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Создаем действие редактирования
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            // Обработка нажатия на кнопку редактирования
           self?.pressEditTask(at: indexPath)
           completionHandler(true)
        }
        editAction.backgroundColor = .blue

        // Создаем действие удаления
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
           // Обработка нажатия на кнопку удаления
            self?.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
            self?.saveTasks()
        }

        // Возвращаем конфигурацию с обеими кнопками
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
