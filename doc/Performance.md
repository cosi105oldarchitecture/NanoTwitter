# Performance Analysis

### Benchmarks

Loader.io Tests:

Test:  
_Maintain Client Load: Login+Tweets (0-30/00:15)_

Notable Changes

- `v0.5` --> `v0.6`
  - Indexed users, follows, tweets, timeline_pieces
- `v0.4` --> `v0.5`
  - Denormalized timeline_pieces & tweet data
  - Switched from Webrick to Thin

| Version | Avg     | Min    | Max     | Successes | Errors |
| ------: | ------: | -----: | ------: | --------: | -----: |
| v0.5    | 881 ms  | 76 ms  | 2031 ms | 462       | 0      |
| v0.4    | 1857 ms | 302 ms | 3436 ms | 198       | 0      |
