//
//  FactoryTests.swift
//  FactoryTests
//
//  Created by Hoorad Ramezani on 2/7/21.
//
import Foundation
import XCTest
@testable import Factory

class FlowTest: XCTestCase{
    

    
    func test_Start_With_NoQuestion_doesNotRoutedToQuestion(){
        makeSUT(question: []).start()
        XCTAssertTrue(router.routerQuestions.isEmpty)
    }
    
    func test_Start_With_OneQuestion_route_ToCorrectQuestion(){
        makeSUT(question: ["Q1","Q2"]).start()
        XCTAssertEqual(router.routerQuestions, ["Q1"])
    }
    
    func test_Start_With_Tow_Question_route_TofirstQuestion(){
        makeSUT(question: ["Q1","Q2"]).start()
        XCTAssertEqual(router.routerQuestions, ["Q1"])
    }
    
    func test_Start_With_Tow_Question_route_To_first_QuestionTwice(){
        let sut = makeSUT(question: ["Q1","Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routerQuestions, ["Q1","Q1"])
    }
    
    func test_StartAnd_answerFirst_Questions_route_To_Second_Question(){
        let sut = makeSUT(question: ["Q1","Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routerQuestions, ["Q1","Q2"])
    }
    
    func test_Start_answerFirstAndSecound_Questions_routeToSecondAndThird_Question(){
        
        let sut = makeSUT(question: ["Q1","Q2","Q3"])
        sut.start()
        XCTAssertEqual(router.routerQuestions, ["Q1"])
        router.answerCallBack("A1")
        XCTAssertEqual(router.routerQuestions, ["Q1","Q2"])
        router.answerCallBack("A2")
        XCTAssertEqual(router.routerQuestions, ["Q1","Q2","Q3"])
    }
    
    func test_Start_answerFirst_Questions_WithOneQuestion_doesNotRoutedToQuestion(){
        
        let sut = makeSUT(question: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routerQuestions, ["Q1"])
    }
    
    
    // MARK: Helper
    
    let router = RouterSpy()

    func makeSUT(question: [String]) -> Flow{
        return Flow(router: router, question: question)
    }
    
    class RouterSpy : Router{
        var routerQuestions: [String] = []
        var answerCallBack: ((String) -> Void) = {_ in}
        
        func routeTo(question: String, answerCallBack: @escaping (String) -> Void){
            routerQuestions.append(question)
            self.answerCallBack = answerCallBack
        }
        
    }
    
}
