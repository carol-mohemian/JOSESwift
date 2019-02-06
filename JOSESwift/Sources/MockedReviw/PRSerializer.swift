//
//  MockedSerializer.swift
//  JOSESwift
//
//  Created by Carol Capek on 06.02.19.
//

import Foundation

struct PRSerializer {
    func serialize(headerParameterAlgorithm: String, headerParametertyp: String, headerParameterKID: String, jws_payload: NSString, signature: Data) -> String? {
        let header = [
            "alg": headerParameterAlgorithm,
            "typ": headerParametertyp,
            "kid": headerParameterKID,
        ]

        let headerJSON = try! JSONEncoder().encode(header)

        var payload = (jws_payload as String).data(using: .utf8)!

        // The structure of a serialized JWS looks like the following: header.payload.signature
        var serialisation = headerJSON.base64URLEncodedString()
        serialisation = serialisation.appending(".")
        serialisation = serialisation.appending(payload.base64URLEncodedString())
        serialisation = serialisation.appending(".")
        serialisation = serialisation.appending(signature.base64URLEncodedString())

        return serialisation
    }

    func derialize(serialization: String?) -> (header: String, payload: String, signature: String)? {
        // First element in the serialized JWS is the header
        let headerDotIndex = serialization?.firstIndex(of: ".")

        var header = serialization![serialization!.startIndex..<headerDotIndex!]

        if var remainingSerialization = serialization {
            remainingSerialization = String(serialization![headerDotIndex!..<serialization!.endIndex])
            remainingSerialization.removeFirst()

            let payloadDotIndex = remainingSerialization.firstIndex(of: ".")

            var payload = remainingSerialization[remainingSerialization.startIndex..<payloadDotIndex!]

            remainingSerialization.removeFirst()

            let signature = remainingSerialization

            return (String(header), String(payload), String(signature))
        }

        return nil
    }
}
