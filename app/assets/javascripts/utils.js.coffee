define ['jquery'], ($) ->
  utils =
    pluralizeWord: (count, singular, plural) ->
      (if (count is 1 or /^1(\.0+)?$/.test(count)) then singular else (plural))

  utils
