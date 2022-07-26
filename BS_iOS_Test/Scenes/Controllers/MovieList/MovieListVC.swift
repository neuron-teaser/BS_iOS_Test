//
//  MovieListVC.swift
//  BS-iOS-Test
//
//  Created by Jamil Bin Hossain on 6/5/21.
//

import UIKit

class MovieListVC: UIViewController {
    
    var coordinator: MovieListVCCoordinator?
    private(set) var movieViewModel = MovieViewModel()
    private let activity = ActivityIndicator()
    var imgUrl = "https://image.tmdb.org/t/p/w500"
    
    var searching = false
    var searchedMovie = ["Marvel"]
    
    var searchedImg = ["ten"]
    
    var searchedMovieDetails = ["The story follows"]
        
    var titleArray = ["Captain Marvel","Marvel Captain","Captain Sir allad","Heello  Marvel","Cornoy Marvel","Convoy Marvel","Convoy Marvel","Captain Captain","Marvel Marvel","Marvel Captain","Captain Marvel","Captain Marvel","Captain Marvel","Captain Captain" ]
    
    
    var movieDetailsArray = ["The story follows"]
    
    var imageArray = ["ten"]
    
    let searchController = UISearchController()

    @IBOutlet weak var tableView: UITableView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movieViewModel.viewDidLoad(self)

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchMovieList()
        initSearchController()
    }
    
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Marvel", "Harry Potter"]
        searchController.searchBar.delegate = self
    }
    
}

//MARK:- Tost

extension MovieListVC: LoaderDelegate{
    
    func showLoader() {
        DispatchQueue.main.async { [self] in
            activity.showLoading(view: self.view)
        }
    }
    
    func hideLoader() {
        activity.hideLoading()
    }
}

//MARK:- Loader
extension MovieListVC:TostDelegate {
    func showTostWith(mess: String) {
        DispatchQueue.main.async {
            ToastView.shared.short(self.view, txt_msg: "  \(mess)  ")
        }
    }
}

extension MovieListVC : UITableViewDelegate, UITableViewDataSource , UISearchResultsUpdating, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchController.isActive)
        {
            return searchedMovie.count
        }
        return movieViewModel.movieItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieListTVCell
        
        if(searchController.isActive)
        {
            var vm: MovieCellViewModel?
            vm = self.movieViewModel.getMovieList(at: indexPath.row)

            if let vm = vm {
                cell.movieTitle.text = vm.original_title
                cell.movieDetails.text = vm.overview
                
                let imgPath = imgUrl + vm.poster_path
                let url = URL(string: imgPath)
                
                getData(from: url!) { data, response, error in
                        guard let data = data, error == nil else {
                            cell.movieThumbImage.image = UIImage(systemName: "DummyImage")
                            return
                        }
                       
                        // always update the UI from the main thread
                        DispatchQueue.main.async() { [weak self] in
                            cell.movieThumbImage.image = UIImage(data: data)
                        }
                    }
            }
            
            //cell.movieThumbImage.image = UIImage(named: searchedImg[indexPath.row])
            //cell.movieTitle.text = searchedMovie[indexPath.row]
            //cell.movieDetails.text = searchedMovieDetails[indexPath.row]
        }
        else
        {
            var vm: MovieCellViewModel?
            vm = self.movieViewModel.getMovieList(at: indexPath.row)

            if let vm = vm {
                cell.movieTitle.text = vm.original_title
                cell.movieDetails.text = vm.overview
                
               
                let imgPath = imgUrl + vm.poster_path
                let url = URL(string: imgPath)
                
                if vm.poster_path.isEmpty {
                    cell.movieThumbImage.image = UIImage(named: "DummyImage")
                }
                else {
                    getData(from: url!) { data, response, error in
                            guard let data = data, error == nil else {
                                return
                            }
                           
                            // always update the UI from the main thread
                            DispatchQueue.main.async() { [weak self] in
                                    cell.movieThumbImage.image = UIImage(data: data)
                            }
                        }
                }
            }
        }
        
        return cell
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        //searchedImg.removeAll()
        searchedMovie.removeAll()
        //searchedMovieDetails.removeAll()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton : String = "All")
    {
        searchedMovie = titleArray.filter
        {
            shape in
            let scopeMatch = (scopeButton == "All" || shape.lowercased().contains(scopeButton.lowercased()))
            if(searchController.searchBar.text != "")
            {
                let searchTextMatch = shape.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            }
            else
            {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}


extension MovieListVC: MovieViewModelDelegate {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func fetchMovieList(){
        self.movieViewModel.getMovieSearchLists(resource: movieViewModel.createMovieSearchListRequest())
    }
}
