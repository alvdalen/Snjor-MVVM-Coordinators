//
//  NetworkService + Requestable.swift
//  Snjor
//
//  Created by Адам on 15.06.2024.
//

import Foundation

extension NetworkService: Requestable {
  // MARK: - Public Methods
  func request<T>(
    request: URLRequest,
    type: T.Type
  ) async throws -> T
  where T: Decodable {
    return try await makeRequest(request: request)
  }

  // MARK: - Private Methods
  private func makeRequest<T>(
    request: URLRequest
  ) async throws -> T
  where T: Decodable {
    let request = try await session.data(for: request)
    return try validateResponse(request: request)
  }

  private func validateResponse<T>(
    request: (data: Data, httpResponse: URLResponse)
  ) throws -> T
  where T: Decodable {
    guard let httpResponse = request.httpResponse as? HTTPURLResponse else {
      throw APIError.responseError
    }

    switch httpResponse.statusCode {
    case HTTPResponseStatus.success:
      return try decodeResponse(data: request.data)
    case HTTPResponseStatus.clientError:
      throw APIError.clientError
    case HTTPResponseStatus.serverError:
      throw APIError.serverError
    default:
      throw APIError.unknownError
    }
  }

  private func decodeResponse<T>(data: Data) throws -> T where T: Decodable {
    let decoder = JSONDecoder()
    let model = try? decoder.decode(T.self, from: data)
    guard let model = model else {
      throw APIError.decodingError
    }
    return model
  }
}
