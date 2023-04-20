import Foundation

protocol PostFavoritesDataProviderProtocol {
    
    func getListByBloggerPost(postIdsFilter: [String], bloggerIdFilter: String?, completionHandler: @escaping ([String:[PostFavorites]]) -> Void)
    
    func getListByBlogger(limit: Int, bloggerIdFilter: String, beforeAddedAtFilter: Date?, completionHandler: @escaping ([PostFavorites], _ hasMore: Bool) -> Void)
}
