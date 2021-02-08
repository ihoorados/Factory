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
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_Start_With_OneQuestion_route_ToCorrectQuestion(){
        makeSUT(question: ["Q1","Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_Start_With_Tow_Question_route_TofirstQuestion(){
        makeSUT(question: ["Q1","Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_Start_With_Tow_Question_route_To_first_QuestionTwice(){
        let sut = makeSUT(question: ["Q1","Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }
    
    func test_StartAnd_answerFirst_Questions_route_To_Second_Question(){
        let sut = makeSUT(question: ["Q1","Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2"])
    }
    
    func test_Start_answerFirstQuestions_WithOneQuestion_doesNotRoutedToQuestion(){
        let sut = makeSUT(question: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_Start_With_NoQuestion_tRoutedToResult(){
        makeSUT(question: []).start()
        XCTAssertEqual(router.routedResult , [:] )
    }
    
    func test_Start_With_OneQuestion_doesNotRoutedToResult(){
        makeSUT(question: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }
        
    func test_Start_AndAnswerFirstQuestion_WithTowQuestion_doesNotRoutedToResult(){
        let sut = makeSUT(question: ["Q1","Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertNil(router.routedResult)
    }
    
    // MARK: Helper
    
    let router = RouterSpy()
    func makeSUT(question: [String]) -> Flow<String, String, RouterSpy>{
        return Flow(router: router, question: question)
    }
    
    class RouterSpy : Router{
        
        var routedQuestions: [String] = []
        var routedResult: [String:String]? = nil
        var answerCallBack: (String) -> Void = { _ in }
        
        func routeTo(question: String, answerCallBack: @escaping (String) -> Void){
            routedQuestions.append(question)
            self.answerCallBack = answerCallBack
        }
        
        func routeTo(result: [String:String]){
            routedResult = result
        }
        
    }
    
}
