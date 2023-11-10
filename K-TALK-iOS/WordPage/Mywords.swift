import Foundation

func makeAPICall() {
    let openApiURL = "http://aiopen.etri.re.kr:8000/WiseWWN/Word"
    let accessKey = "" // 발급받은 API Key
    let word = "배" // 정보를 조회할 어휘 데이터
    
    let argument : [String : Any] = ["word" : word] as Dictionary
    let parameters : [String: Any] = ["argument" : argument] as Dictionary

    // API 요청에 사용할 데이터 모델 생성
    let requestModel = parameters

    var url: URL
    var responseCode: Int?
    var responseBody: String?

    do {
        url = URL(string: openApiURL)!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(accessKey, forHTTPHeaderField: "Authorization")

        // Encode the request model to JSON data

//        if let requestBody = try? JSONEncoder().encode(requestModel) {
//            request.httpBody = requestBody
//        } else {
//            print("Error encoding request body to JSON")
//            return
//        }
        do{
            try request.httpBody = JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }catch{
            print("Error")
        }

        // API 호출
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                responseCode = (response as? HTTPURLResponse)?.statusCode
                responseBody = String(data: data, encoding: .utf8)
                print("[responseCode] \(responseCode ?? 0)")
                print("[responseBody]")
                print(responseBody ?? "")
            }
        }

        task.resume()
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

//struct WordRequest: Codable {
//    let argument: Argument
//}
//
//struct Argument: Codable {
//    let word: String
//}

 
