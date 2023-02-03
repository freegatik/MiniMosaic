//
//  MiniMosaicModelTests.swift
//  MiniMosaicTests
//
//  Created by Anton Solovev on 03.02.2023.
//

import XCTest
@testable import MiniMosaic

final class WeatherModelDecodingTests: XCTestCase {
    func testDecodeOpenWeatherShape() throws {
        let json = Data(
            """
            {"main":{"temp":12.5},"weather":[{"description":"clear sky"}],"name":"Berlin"}
            """.utf8
        )
        let model = try JSONDecoder().decode(WeatherModel.self, from: json)
        XCTAssertEqual(model.name, "Berlin")
        XCTAssertEqual(model.main.temp, 12.5, accuracy: 0.001)
        XCTAssertEqual(model.weather.count, 1)
        XCTAssertEqual(model.weather.first?.description, "clear sky")
    }
}

final class NewsModelDecodingTests: XCTestCase {
    func testDecodeNewsResponseWithNullableDescription() throws {
        let json = Data(
            """
            {"articles":[{"title":"Hello","description":"World"},{"title":"No desc","description":null}]}
            """.utf8
        )
        let response = try JSONDecoder().decode(NewsResponse.self, from: json)
        XCTAssertEqual(response.articles.count, 2)
        XCTAssertEqual(response.articles[0].title, "Hello")
        XCTAssertEqual(response.articles[0].description, "World")
        XCTAssertNil(response.articles[1].description)
    }
}

final class LocationModelTests: XCTestCase {
    func testLocationModelStoresFields() {
        let model = LocationModel(city: "Kyiv", coordinates: "Широта: 1.00, Долгота: 2.00")
        XCTAssertEqual(model.city, "Kyiv")
        XCTAssertEqual(model.coordinates, "Широта: 1.00, Долгота: 2.00")
    }
}

final class MiniAppListViewModelTests: XCTestCase {
    func testCompactLayoutDisablesInteractionAndUsesOneEighthHeight() {
        XCTAssertEqual(MiniAppGridLayoutMode.compactRows.cellHeightFactor, 1.0 / 8.0, accuracy: 0.000_001)
        XCTAssertFalse(MiniAppGridLayoutMode.compactRows.interactionEnabled)
    }

    func testHalfLayoutEnablesInteraction() {
        XCTAssertEqual(MiniAppGridLayoutMode.halfRows.cellHeightFactor, 0.5, accuracy: 0.000_001)
        XCTAssertTrue(MiniAppGridLayoutMode.halfRows.interactionEnabled)
    }

    func testLoadMiniAppsUsesDefaultCount() {
        let vm = MiniAppListViewModel(factory: MiniAppFactory(environment: .live))
        vm.loadMiniApps()
        XCTAssertEqual(vm.miniApps.count, 14)
    }

    func testSetLayoutModeUpdatesState() {
        let vm = MiniAppListViewModel(factory: MiniAppFactory(environment: .live))
        vm.setLayoutMode(.fullRows)
        XCTAssertEqual(vm.layoutMode, .fullRows)
        XCTAssertEqual(vm.cellHeightFactor, 1.0)
        XCTAssertTrue(vm.interactionEnabled)
    }
}
