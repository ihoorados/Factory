//
//  Flow.swift
//  Factory
//
//  Created by Hoorad Ramezani on 2/7/21.
//

import Foundation

protocol Router {
    typealias AnswerCallBack = (String) -> Void
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
}

class Flow{
    
    private let router : Router
    private let Question: [String]
    
    init(router:Router,question:[String]) {
        self.router = router
        self.Question = question
    }
    
    func start(){
        if let firstQuestion = Question.first{
            router.routeTo(question: firstQuestion, answerCallBack: routeNext(from:firstQuestion))
        }
    }
    
    private func routeNext(from question:String) -> Router.AnswerCallBack{
        
        return{ [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let CurrentQuestionIndex = strongSelf.Question.firstIndex(of:question){
                if CurrentQuestionIndex+1 < strongSelf.Question.count{
                    let nextQuestion = strongSelf.Question[CurrentQuestionIndex + 1]
                    strongSelf.router.routeTo(question: nextQuestion, answerCallBack: strongSelf.routeNext(from:nextQuestion))
                }
            }

        }

    }
}
