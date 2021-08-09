# Async HTTP
This function, used in conjunction with `#!gd yield()`, allow codes to wait for a HTTP response without using signals or blocking the main thread. It is the core of this API.

!!! example
    ```gd
    # The returned response is a String.
    var response = yield(_async_http("http://google.com"), "completed")
    # Basically print out Google's home page.
    print(response)
    ```
