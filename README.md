# Vocab Tool

This is an iOS app for spaced repetition flash card practice with some specific features oriented towards studying vocabulary in a foreign language.

## Usage
It is only currently intended for my own personal use, but if you want to try it out or fork it, feel free (but please change the bundle identifier to something not beginning with my domain if you do).

It's a document-based app that
opens JSON files with the .vocab extension. Pressing "New Document" in the app will generate a valid file that you can edit outside of the app to add your
vocabulary words. Here is an example of a valid document with a few words:

```JSON
{
    "lastStudyDayNewCardCount": 0,
    "maxReviewsPerDay": 40,
    "lastStudyDaySeenCards": [],
    "lastStudyDate": 683002244.59983003,
    "maxNewCardsPerDay": 10,
    "lastStudyDayReviewCount": 0,
    "items": [
        {
            "word": "転勤",
            "pronunciation": "てんきん",
            "meaning": "job transfer/relocation",
            "state": "untouched",
            "priority": 1,
            "lastBreak": 0
        },
        {
            "word": "記憶",
            "pronunciation": "きおく",
            "meaning": "memory, remembrance, computer memory",
            "state": "untouched",
            "priority": 2,
            "lastBreak": 0
        },
        {
            "word": "寿司",
            "meaning": "sushi",
            "state": "untouched",
            "priority": 3,
            "lastBreak": 0
        }
    ]
}
```

The only field you _need_ to edit from the default to get anything out of the app is the `items` array, which contains your vocab words (it is blank in the default new document).
Technically you can add words in the app through the GUI, but it's really slow compared to generating the JSON programattically or through regex find/replace against a list of words copied from some other source.
- The `word` field is the only field that will be shown to you on the "question" side of the flash card.
- The `pronunciation` field is optional, and if provided, it can be revealed on the "question" side of the card by tapping the
"Tap to reveal pronunciation" button.
- The `meaning` field is shown on the "answer" side of the flash card when you tap to flip the card.
- The `state` field must be one of the following:
    - `"untouched"`: You have not yet started learning this card. It will eventually appear as one of the new cards for a given day.
    - `"learning"`: You have started learning this card. It will appear on (or after if you reach your study limit before it comes up) the date indicated by the optional `nextReviewDate` field, or immediately if that field is not provided.
    - `"mastered"`: You no longer need to study this word. It will never appear but can be viewed in the vocab list.
- The `priority` field is a number that will appear in the top right of the card like an ID number. I use this because I'm studying a list of the top 2,000 most common words in Japanese and this is their rank, but mostly I just like that it makes it feel like a trading card or something. It's also useful if you notice a mistake or a duplicate, so you know which one to edit.
- The `lastBreak` field indicates how long the break between the last study session and the next one is (for spaced repitition). This defaults to `0`, and the next highest option will be used for the next delay that gets added to the `nextReviewDate` field.

Additionally, there are two options to configure:
- `maxReviewsPerDay` is the maximum number of review cards (words in the `'learning'` state) the app will show you on a given day before declaring your study session complete.
- `maxNewCardsPerDay` is the maximum numebr of new cards (words in the `'untouched'` state) that will be added on a given day before switching over to review cards.

The rest of the fields are for internal use to persist study sessions across app sessions and can be ignored.

Since all persistant data is stored in the file through the system file picker, there is no backend or internet connection needed, although I am considering adding some optional features in the future that will either call public APIs or open a page in a web browser to provide hints or additional info on words.
