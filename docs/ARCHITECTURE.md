# MiniMosaic

- **AppEnvironment** — сервисы для таргета; живой набор в `SceneDelegate`, подмена для тестов.
- **MiniAppFactory** — сборка тайлов.
- **MiniAppListViewModel** — режим сетки и список тайлов.
- **MiniAppListViewController** — collection view, навбар, `CLLocationManager`.
- Сервисы в `Utils/Services`, протоколы в `Core/Services/ServiceProtocols.swift`.
- **AppLog** — `os.Logger`, категория `network`.

Корень: один `UINavigationController`. Строки навбара — `Localizable.xcstrings` (en, ru).

Вне текущего объёма: отдельный coordinator, DTO → domain, Keychain. `CityViewController` / `WeatherViewController` не в основном потоке мозаики.
