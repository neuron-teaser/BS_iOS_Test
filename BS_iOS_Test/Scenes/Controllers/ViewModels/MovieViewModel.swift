//
//  MovieViewModel.swift
//  BS-iOS-Test
//
//  Created by Jamil Bin Hossain on 6/5/21.
//

import Foundation
import UIKit


protocol MovieViewModelDelegate {
    //func showOrHideLoader(loader: Bool)
    //func noInternetToast()
    //func response(status: String, message: String)
    //func successfulldataParse()
    func reloadData()

}

class MovieViewModel {
        
    private(set) var loaderdelegate: LoaderDelegate?
    private(set) var tostDelegate: TostDelegate?
    private(set) var delegate: MovieViewModelDelegate?
    
    func viewDidLoad<T>(_ vc: T) {
        self.loaderdelegate = vc.self as? LoaderDelegate
        self.tostDelegate = vc.self as? TostDelegate
        self.delegate = vc.self as? MovieViewModelDelegate
    }
    
    public var sectionData: [Section] = []
    
    var movieItem: [MovieCellViewModel] {
        didSet {
            sectionData.append(Section(items: movieItem))
            self.delegate?.reloadData()
        }
    }
    
    init() {
        self.movieItem = [MovieCellViewModel]()
    }
    
    func getMovieList(at index: Int) -> MovieCellViewModel {
        return self.movieItem[index]
    }
    
    func createMovieSearchListRequest()-> Resource {
        
        guard let url = URL(string: URL.movieList) else {
            fatalError("URl was incorrect")
        }
        var resource = Resource(url: url)
        resource.httpMethod = HttpMethod.get
        return resource
    }
    
    func getMovieSearchLists(resource: Resource) {
        if Reachability.isConnectedToNetwork() {
    
            self.loaderdelegate?.showLoader()
            
            WebService.load(resource: resource) {[weak self] (result) in
                
                switch result {
                
                case .success(let data, let status):
                    switch status {
                    case HTTPStatusCodes.OK:
                        self?.loaderdelegate?.hideLoader()
                        JSONDecoder.decodeData(model: MovieListDataModel.self, data) { [weak self](result) in
                            switch result
                            {
                            case .success(let data):
                              
                                if let results = data.results {
                                    self?.movieItem = results.map(MovieCellViewModel.init)
                                }
                                
                                print("Here is the number of pages: \(data.page)")
                                print("Here is the number of total pages: \(data.total_pages)")
                                print("Here is the number of total results: \(data.total_results)")
                                print("Here is the number of array elements: \(data.results?.count)")
                                
                                
                                break
                            case .failure(let error):
                                self?.loaderdelegate?.hideLoader()
                                print(error)
                                break
                            }
                        }
                        break
                    case HTTPStatusCodes.BadRequest:
                        self?.loaderdelegate?.hideLoader()
//                        self?.tostDelegate?.showTostWith(mess: LocalizationSystem.shared.localizedStringForKey(key: "Opps! Something went wrong", comment: ""))
                        break
                        
                    case HTTPStatusCodes.InternalServerError:
                        self?.loaderdelegate?.hideLoader()
//                        self?.tostDelegate?.showTostWith(mess: LocalizationSystem.shared.localizedStringForKey(key: "Opps! Something went wrong", comment: ""))
                        break
                        
                    case HTTPStatusCodes.NotFound:
                        self?.loaderdelegate?.hideLoader()
//                        self?.tostDelegate?.showTostWith(mess: LocalizationSystem.shared.localizedStringForKey(key:  "No data found", comment: ""))
                        break
                        
                    default:
                        self?.loaderdelegate?.hideLoader()
//                        self?.tostDelegate?.showTostWith(mess: LocalizationSystem.shared.localizedStringForKey(key: "Opps! Something went wrong", comment: ""))
                        break
                        
                    }
                    break
                case .failure(let error):
                    self?.loaderdelegate?.hideLoader()
//                    self?.tostDelegate?.showTostWith(mess: LocalizationSystem.shared.localizedStringForKey(key: "Opps! Something went wrong", comment: ""))
                    print(error.localizedDescription)
                    break
                }
            }
        } else {
//            self.tostDelegate?.showTostWith(mess: LocalizationSystem.shared.localizedStringForKey(key: "Please check your internet connection and try again!", comment: ""))
        }
    }

}

struct MovieCellViewModel {
    var listData: MovieListData
}

extension MovieCellViewModel {
        
    var id: Int {
        guard let movieId = listData.id else {
            fatalError("no id")
        }
        return movieId
    }
    
    var title: String {
        
        if let title = listData.title {
            return title
        } else {
            return ""
        }

    }
    
    var original_title: String {
        if let original_title = listData.original_title {
            return original_title
        } else {
            return ""
        }
        
    }
    
    var overview: String {
        if let overview = listData.overview {
            return overview
        } else {
            return ""
        }
        
    }

    var release_date: String {
        if let release_date = listData.release_date {
            return release_date
        } else {
            return ""
        }
        
    }
    
    var poster_path: String {
        if let poster_path = listData.poster_path {
            return poster_path
        } else {
            return ""
        }
    }
}
