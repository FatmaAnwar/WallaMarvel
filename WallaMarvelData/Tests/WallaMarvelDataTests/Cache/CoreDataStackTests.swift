//
//  CoreDataStackTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import CoreData
@testable import WallaMarvelData

@MainActor
final class CoreDataStackTests: XCTestCase {
    
    var sut: CoreDataStack!
    
    override func setUp() async throws {
        sut = CoreDataStack.shared
    }
    
    override func tearDown() async throws {
        sut = nil
    }
    
    func test_persistentContainer_shouldNotBeNil() {
        // When
        let container = sut.persistentContainer
        
        // Then
        XCTAssertNotNil(container)
        XCTAssertEqual(container.name, "WallaMarvel")
    }
    
    func test_context_shouldBeViewContextOfContainer() {
        // Given
        let container = sut.persistentContainer
        
        // When
        let context = sut.context
        
        // Then
        XCTAssertEqual(context, container.viewContext)
    }
    
    func test_saveContext_whenNoChanges_shouldNotThrow() {
        // Given
        let context = sut.context
        XCTAssertFalse(context.hasChanges)
        
        // When
        sut.saveContext()
        
        // Then
        XCTAssertNoThrow(sut.saveContext())
    }
    
    func test_saveContext_whenHasChanges_shouldPersist() {
        // Given
        let context = sut.context
        let entity = NSEntityDescription.entity(forEntityName: "CDCharacter", in: context)!
        let character = NSManagedObject(entity: entity, insertInto: context)
        character.setValue(101, forKey: "id")
        character.setValue("Mock", forKey: "name")
        character.setValue("Some", forKey: "desc")
        character.setValue("img", forKey: "imageUrl")
        
        XCTAssertTrue(context.hasChanges)
        
        // When & Then
        XCTAssertNoThrow(sut.saveContext())
    }
    
    func test_saveContext_whenSaveFails_shouldNotCrash() {
        // Given
        let context = sut.context
        let entity = NSEntityDescription.entity(forEntityName: "CDCharacter", in: context)!
        let character = NSManagedObject(entity: entity, insertInto: context)
        character.setValue(nil, forKey: "name")
        
        // When & Then
        XCTAssertNoThrow(sut.saveContext())
    }
}
