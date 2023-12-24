//
//  SuggestItem.swift
//  MapSearch
//

import YandexMapsMobile

struct SuggestItem {
    let title: YMKSpannableString
    let subtitle: YMKSpannableString?
    let onClick: () -> Void
}
