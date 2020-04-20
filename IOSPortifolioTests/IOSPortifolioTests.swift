//
//  IOSPortifolioTests.swift
//  IOSPortifolioTests
//
//  Created by Jefferson Puchalski on 17/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import XCTest
@testable import IOSPortifolio

class IOSPortifolioTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCNPJMask() {
           // Variables
           let cnpjUnmaskGood = "08936555000151" //08.936.555/0001-51
           let cnpjMaskedGood = "08.936.555/0001-51" //08.936.555/0001-51
           
           //1
           // Check unmask cpfs
           let unmaskedGood = cnpjMaskedGood.removeAllMaskCharacters()
           XCTAssertTrue(cnpjUnmaskGood == unmaskedGood, "Failed -> The cnpj must be exactly equal to his unmask version")
       }
       
       func testCPFMask(){
           // Variables and setters
           let cpnjmaskedGood = "094.003.956-71"
           let cpnjUnMaskedGood = "09400395671"
           
           //1
           // Check unmask cpfs
           let unmaskedGood = cpnjmaskedGood.removeAllMaskCharacters()
           XCTAssertTrue(unmaskedGood == cpnjUnMaskedGood, "Failed -> The CNPJ must be exactly equal to his unmask version") //
       }
       
      
       
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
