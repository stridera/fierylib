"""
Keyword normalizer - removes articles and normalizes keywords for consistent matching
"""

# Common articles to strip from keywords
ARTICLES = {"a", "an", "the", "some"}


def strip_articles(keywords: list[str]) -> list[str]:
    """
    Remove article words (a, an, the, some) from a keyword list.

    Args:
        keywords: List of keywords

    Returns:
        List with articles removed

    Example:
        >>> strip_articles(["a", "lantern", "brass"])
        ["lantern", "brass"]
        >>> strip_articles(["the", "sword", "of", "doom"])
        ["sword", "of", "doom"]
    """
    return [kw for kw in keywords if kw.lower() not in ARTICLES]


def normalize_keywords(keywords: list[str]) -> list[str]:
    """
    Normalize keywords by:
    1. Stripping articles (a, an, the, some)
    2. Lowercasing all keywords
    3. Removing empty strings

    Args:
        keywords: List of keywords

    Returns:
        Normalized keyword list
    """
    result = []
    for kw in keywords:
        kw_lower = kw.lower().strip()
        if kw_lower and kw_lower not in ARTICLES:
            result.append(kw_lower)
    return result
