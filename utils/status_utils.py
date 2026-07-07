"""Status normalization helpers.

Provide a single place to map various status synonyms to a canonical
database-friendly status string. This keeps server-side writes consistent
and makes client filtering more reliable.
"""

from typing import Optional


def normalize_db_status(status: Optional[str]) -> str:
    """Normalize an input status string to a canonical DB value.

    Returns a title-cased canonical status (e.g. 'Open', 'Pending',
    'Accepted', 'Ongoing', 'Resolved', 'Invalid', 'Unresolved').
    Unknown values are returned title-cased as a sensible fallback.
    """
    if not status:
        return ''
    s = str(status).strip().lower()
    mapping = {
        'open': 'Open',
        'new': 'Open',
        'pending': 'Pending',
        'accepted': 'Accepted',
        'accept': 'Accepted',
        'reject': 'Invalid',
        'rejected': 'Invalid',
        'invalid': 'Invalid',
        'declined': 'Invalid',
        'in progress': 'Ongoing',
        'in-progress': 'Ongoing',
        'processing': 'Ongoing',
        'assigned': 'Ongoing',
        'ongoing': 'Ongoing',
        'resolved': 'Resolved',
        'closed': 'Resolved',
        'unresolved': 'Unresolved',
    }
    return mapping.get(s, s.title())


def normalize_status_key(status: Optional[str]) -> str:
    """Return a lower-case normalized key for client-side comparisons."""
    val = normalize_db_status(status)
    return val.lower() if val else ''
