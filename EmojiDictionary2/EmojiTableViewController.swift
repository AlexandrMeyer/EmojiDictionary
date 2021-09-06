//
//  EmojiTableViewController.swift
//  EmojiDictionary2
//
//  Created by Александр on 19.04.21.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
        Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // Указываю лейблу что высота строки должна соответствовать количеству содержимого
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    // Активирую кнопку Item
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if let saveEmoji = Emoji.loadFromFile() {
            emojis = saveEmoji
        } else {
            emojis = Emoji.sampleEmojis()
        }
        
        Emoji.saveToFile(emojis: emojis)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Step 1: Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        
        // Step 2: Fetch model object to display
        let emoji = emojis[indexPath.row]
        
        // Step 3: Configure cell
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        // Step 4: Return cell
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let emoji = emojis[indexPath.row]
//        print("\(emoji.symbol) \(indexPath)")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Режим редактирования ячеек (Edit Table Views)
    // Исключение строки из редактирования (используется не часто)
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
//    Метод определят стиль редактирования строки
        override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }

//    Метод обновляет модель данных чтобы отразить действие пользлвателя (Метод реализуется если базе данных нужно удалить или вставить строку)
   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
       }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let moveEmoji = emojis.remove(at: fromIndexPath.row)
        emojis.insert(moveEmoji, at: to.row)
    }

    // MARK: - Navigation
    @IBSegueAction func addEmoji(_ coder: NSCoder, sender: Any?) -> AddEmojiTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
      //  Editing Emoji
            let emojiToEdit = emojis[indexPath.row]
            return AddEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
     //  Adding Emoji
        return AddEmojiTableViewController(coder: coder, emoji: nil)
    }
}
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
//        Проверяю что было выбрано, редактирование или добавление и соответственно редактирую старый или добавляю новый эмоджи в массив
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEmojiTableViewController,
              let emoji = sourceViewController.emoji else { return }
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
