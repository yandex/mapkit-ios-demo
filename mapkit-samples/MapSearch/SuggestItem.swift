//
//  SuggestItem.swift
//  MapSearch
//
//  Created by Daniil Pustotin on 14.08.2023.
//

import YandexMapsMobile

struct SuggestItem {
    let title: YMKSpannableString
    let subtitle: YMKSpannableString?
    let onClick: () -> Void
}
