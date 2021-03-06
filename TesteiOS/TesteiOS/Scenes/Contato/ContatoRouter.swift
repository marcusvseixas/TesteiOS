//
//  ContatoRouter.swift
//  TesteiOS
//
//  Created by marcus.v.seixas on 04/05/18.
//  Copyright (c) 2018 marcus.v.seixas. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ContatoRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ContatoDataPassing
{
  var dataStore: ContatoDataStore? { get }
}

class ContatoRouter: NSObject, ContatoRoutingLogic, ContatoDataPassing
{
  weak var viewController: ContatoViewController?
  var dataStore: ContatoDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ContatoViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ContatoDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
