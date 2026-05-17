//
//  DesignSystemTests.swift
//  ICOSTests
//
//  Design System Component Tests
//

import Testing
@testable import ICOS

struct DesignSystemTests {

    @Test func iconRegistryResolution() async throws {
        let registry = IconRegistry.shared
        let icon = ICOSIcon.home
        let path = registry.resolve(icon)
        #expect(!path.isEmpty)
    }

    @Test func iconEnumPathMapping() async throws {
        let homeIcon = ICOSIcon.home
        #expect(homeIcon.path.contains("home.svg"))
    }

    @Test func iconCatalogRootURL() async throws {
        let url = ICOSIcon.catalogRootURL
        #expect(url.path.contains("icons"))
    }

}
