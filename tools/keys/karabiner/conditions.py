IF_DEVICE_IS_APPLE_INTERNAL_KEYBOARD = [
    {
        "type": "device_if",
        "identifiers": [
            {
                "vendor_id": 1452,
                "product_id": 832,
                "is_keyboard": True,
            }
        ],
    },
]

IF_DEVICE_IS_EXTERNAL_MOUSE = [
    {
        "type": "device_if",
        "identifiers": [
            {
                "vendor_id": 1111,
                "product_id": 111,
            }
        ],
    }
]

IF_FRONT_APPLICATION_IS_BRAVE = [
    {
        "type": "frontmost_application_if",
        "bundle_identifiers": [
            r"^com\.brave\.Browser$",
        ],
    }
]
