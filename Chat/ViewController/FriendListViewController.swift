import UIKit

class FriendListViewController:BaseViewController {

    var friendList : [UserModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friend";
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: String(describing: FriendTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        let navButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriendAction))
        navigationItem.rightBarButtonItem = navButton
        checkLoginFlow(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFriendList()
    }
    
    @objc func addFriendAction(){
        Tool().confirmAction(in: self, withTitle: "Add Friend", andPlaceholders: ["Friend Id"]) { Result, String in
            if Result{
                for friendModel in self.friendList {
                    if friendModel.friendId == String?[0] ?? "" {
                        UIAlertController.showAlert(in: self, withTitle: "你已經有這個朋友了")
                        return
                        
                    }
                }
                UserAPI.requestAddFriendAction(friendId: String?[0] ?? "") { [weak self]Success in
                    if Success{
                        self?.getFriendList()
                    }else{
                        UIAlertController.showAlert(in: self, withTitle: "找不到這個朋友")
                    }
                }
            }
        }
        
    }
    
    func getFriendList(){
        loadUI.showLoadUI()
        UserAPI.requestFriendList {[weak self] userModelList in
            self?.loadUI.stopLoadUI()
            self?.friendList = userModelList
            self?.tableView.reloadData()
        }
    }
}
extension FriendListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendTableViewCell.self), for: indexPath)
        cell.textLabel?.text = friendList[indexPath.row].email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let ChatViewController = storyboard.instantiateViewController(withIdentifier: "Chat") as!ChatViewController
        ChatViewController.friendModel = friendList[indexPath.row]
        navigationController?.pushViewController(ChatViewController, animated: true)
    }
}
