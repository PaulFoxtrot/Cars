//
//  AppDelegate.swift
//  NewCarList
//
//  Created by foxtrot on 27/05/2019.
//  Copyright © 2019 foxtrot. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadData()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    private func preloadData() {
        
        
        let preloadedDataKey = "didPreloadData"
        
        let userDefaults = UserDefaults.standard
        
// ------------------------------------
//   Почему-то срабатывает только если удалить приложение : (
// ------------------------------------
        if userDefaults.bool(forKey: preloadedDataKey) == false {
 
// ------------------------------------
//          Я не успел разобраться, как подгружать данные из Предзагрузочного файла (PreloadData.plist), поэтому в итоге вручную прописал первые три машины
// ------------------------------------
            
//            guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "plist") else {
//                return
//            }
            
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            backgroundContext.perform {
//            if let arrayContents = NSArray(contentsOf: urlPath) as? [Dictionary<String, Any>] {
                    
                    do {
                        let carObject1 = Car(context: backgroundContext)
                        
                        carObject1.name = "Машина директора"
                        carObject1.manufacturer = "ЗИЛ"
                        carObject1.model = "41047"
                        carObject1.clas = "Лимузин"
                        carObject1.type = "Легковой"
                        carObject1.year = 1999
                        
                        let carObject2 = Car(context: backgroundContext)

                        carObject2.name = "Школьный автобус"
                        carObject2.manufacturer = "ПАЗ"
                        carObject2.model = "3205"
                        carObject2.clas = "Автобус"
                        carObject2.type = "Пассажирский"
                        carObject2.year = 2012
                        
                        let carObject3 = Car(context: backgroundContext)
                        
                        carObject3.name = "Трактор Михалыча"
                        carObject3.manufacturer = "YTO"
                        carObject3.model = "МК-02"
                        carObject3.clas = "Экскаватор"
                        carObject3.type = "Спец. техника"
                        carObject3.year = 1908
                        
                        try backgroundContext.save()
                        // Preload
                        userDefaults.set(true, forKey: preloadedDataKey)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    
    
    
    // MARK: - Core Data stack

    
    lazy var persistentContainer: NSPersistentContainer = {


        let container = NSPersistentContainer(name: "NewCarList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

