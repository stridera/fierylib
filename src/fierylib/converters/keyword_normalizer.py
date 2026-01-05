"""
Keyword normalizer - removes articles and normalizes keywords for consistent matching
"""

import re
from typing import Tuple, Optional

# Common articles to strip from keywords
ARTICLES = {"a", "an", "the", "some"}

# Regex to match article at start of string (case-insensitive)
ARTICLE_PATTERN = re.compile(r'^(a|an|the|some)\s+', re.IGNORECASE)

# Regex to match XML-Lite tags
TAG_PATTERN = re.compile(r'<[^>]*>')


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


def extract_article(name: str, plain_name: str) -> Tuple[Optional[str], str, str]:
    """
    Extract article from a name and return (article, base_name, plain_base_name).

    The article is determined from the plain_name, then removed from both versions.

    Args:
        name: Name with XML-Lite color markup (e.g., "<red>a sword</>")
        plain_name: Plain text version (e.g., "a sword")

    Returns:
        Tuple of:
        - article: The article found (None for standard a/an, "the", "some", or "" for no article)
        - base_name: Name without article (preserving colors)
        - plain_base_name: Plain name without article

    Examples:
        >>> extract_article("a sword", "a sword")
        (None, "sword", "sword")

        >>> extract_article("the Holy Grail", "the Holy Grail")
        ("the", "Holy Grail", "Holy Grail")

        >>> extract_article("some iron rations", "some iron rations")
        ("some", "iron rations", "iron rations")

        >>> extract_article("<red>a sword</>", "a sword")
        (None, "<red>sword</>", "sword")

        >>> extract_article("blood", "blood")
        ("", "blood", "blood")
    """
    if not plain_name:
        return ("", name, plain_name)

    # Check for article in plain text
    match = ARTICLE_PATTERN.match(plain_name)

    if not match:
        # No article found - return empty string to indicate no article should be added
        return ("", name, plain_name)

    article_text = match.group(1).lower()  # "a", "an", "the", or "some"
    plain_base_name = plain_name[match.end():]  # Text after article+space

    # For "a" and "an", we use None to indicate calculate at runtime
    # For "the" and "some", we store the specific article
    if article_text in ("a", "an"):
        article = None
    else:
        article = article_text

    # Now remove the article from the colored name
    # This is tricky because the article might be:
    # 1. Before any tags: "a <red>sword</>"
    # 2. Inside a tag: "<red>a sword</>"
    # 3. In its own tag: "<red>a </><blue>sword</>"

    base_name = _remove_article_from_colored_name(name, article_text)

    return (article, base_name, plain_base_name)


def _remove_article_from_colored_name(name: str, article: str) -> str:
    """
    Remove an article (and following space) from a colored name.

    Handles cases where the article is:
    - Before any tags: "a <red>sword</>"
    - Inside a tag: "<red>a sword</>"
    - In its own tag: "<red>a </><blue>sword</>"

    Args:
        name: Colored name with XML-Lite markup
        article: The article to remove (lowercase)

    Returns:
        Name with article removed
    """
    if not name:
        return name

    # Build a regex that matches the article at the "visible start" of the string
    # The visible start can be preceded by opening tags
    # Pattern: ^(<tags>)*(article\s+)

    article_len = len(article)

    # Track position in string
    i = 0
    prefix_tags = []  # Tags that appear before the article

    # Skip leading tags
    while i < len(name):
        if name[i] == '<':
            # Find end of tag
            end = name.find('>', i)
            if end == -1:
                break
            prefix_tags.append(name[i:end+1])
            i = end + 1
        else:
            break

    # Check if remaining text starts with the article
    remaining = name[i:]
    result = None

    if remaining.lower().startswith(article + ' '):
        # Remove article and space
        base = remaining[article_len + 1:]
        # Reconstruct with prefix tags
        result = ''.join(prefix_tags) + base
    elif remaining.lower().startswith(article):
        # Article might be followed by a tag, then space
        # e.g., "<red>a </><blue>sword</>" -> article is "a", followed by " </>"
        after_article = remaining[article_len:]

        # Check for pattern: optional close tag, then space, then more content
        # e.g., "</> sword" or " </><blue>sword"
        j = 0
        while j < len(after_article):
            if after_article[j] == '<':
                # Skip tag
                end = after_article.find('>', j)
                if end == -1:
                    break
                j = end + 1
            elif after_article[j] == ' ':
                # Found space after article (possibly after tags)
                # Skip the space
                j += 1
                base = after_article[j:]
                result = ''.join(prefix_tags) + base
                break
            else:
                # Found non-space, non-tag character - article is part of a word
                break

    # If we got a result, clean up empty tags
    if result is not None:
        result = _cleanup_empty_tags(result)
        return result

    # Article not found at expected position, return original
    return name


def _cleanup_empty_tags(text: str) -> str:
    """
    Remove empty XML-Lite color tags that might result from article removal.

    Examples:
        "<red></>" -> ""
        "<red></><blue>sword</>" -> "<blue>sword</>"
        "<red></>hello" -> "hello"

    Args:
        text: Text with potential empty color tags

    Returns:
        Text with empty tags removed
    """
    if not text:
        return text

    # Remove patterns like <tag></> where there's no content between opening and closing
    # This handles: <red></>, <b:red></>, etc.
    empty_tag_pattern = re.compile(r'<[^>]+></>')

    # Keep removing until no more changes (handles nested empty tags)
    prev_text = None
    while prev_text != text:
        prev_text = text
        text = empty_tag_pattern.sub('', text)

    return text
