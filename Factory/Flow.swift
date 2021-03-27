//
//  Flow.swift
//  Factory
//
//  Created by Hoorad Ramezani on 2/7/21.
//

import Foundation

protocol Router {
    associatedtype Question : Hashable
    associatedtype Answer
    func routeTo(question: Question, answerCallBack: @escaping (Answer) -> Void)
    func routeTo(result:[Question:Answer])
}

class Flow<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer{
    
    private let router : R
    private let Questions: [Question]
    private var result: [Question:Answer] = [:]
    
    init(router:R,question:[Question]) {
        self.router = router
        self.Questions = question
    }
    
    func start(){
        if let firstQuestion = Questions.first{
            router.routeTo(question: firstQuestion, answerCallBack: nextCallBack(from:firstQuestion))
        }else{
            router.routeTo(result: result)
        }
    }
    
    private func nextCallBack(from question:Question) -> (Answer) -> Void{
        return{ [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question,_ answer: Answer){
        
        if let CurrentQuestionIndex = Questions.firstIndex(of:question){
            result[question] = answer
            
            let nextQuestionIndex = CurrentQuestionIndex+1
            if  nextQuestionIndex < Questions.count{
                let nextQuestion = Questions[nextQuestionIndex]
                router.routeTo(
                    question: nextQuestion,
                    answerCallBack: nextCallBack(from:nextQuestion))
            }else {
                router.routeTo(result: result)
            }
        }
    }
    
}
