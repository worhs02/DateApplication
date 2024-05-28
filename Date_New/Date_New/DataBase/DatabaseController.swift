//
//  DatabaseController.swift
//  Date_New
//
//  Created by 송재곤 on 5/28/24.
//

import UIKit
import SQLite

class DatabaseController: UIViewController {

    var db: Connection?

    override func viewDidLoad() {
        super.viewDidLoad()
        // 데이터베이스 파일 경로 설정
        if let dbPath = Bundle.main.path(forResource: "DateAppDataBase", ofType: "db") {
            do {
                // 데이터베이스 연결
                db = try Connection(dbPath)
                print("데이터베이스 연결 성공")
                fetchData()
            } catch {
                print("데이터베이스 연결 실패: \(error)")
            }
        } else {
            print("데이터베이스 파일을 찾을 수 없음")
        }
    }

    func fetchData() {
        guard let db = db else {
            return
        }
        
        // 테이블 정의
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")

        do {
            // 데이터 조회
            for user in try db.prepare(users) {
                print("id: \(user[id]), name: \(user[name])")
            }
        } catch {
            print("데이터 조회 실패: \(error)")
        }
    }
}
