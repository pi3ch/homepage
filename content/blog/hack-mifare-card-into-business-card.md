---
date: '2025-11-16T11:31:27+11:00'
draft: false
title: 'Hack MIFARE Classic Card into an Electronic Business Card'
cover:
  image: /blog/images/nfc-business-card-with-led.jpg
---

I travel a lot for business and need to carry many business cards.
Aside from physical cards, I also have an NFC business card and QR codes on my phone with my contact information (you can build your own [QR business card here](https://hovercode.com/circle-qr-code-generator/)).

At one of my visits to a FinTech festival, I visited the **Goldpac** booth where I learned about their payment, authentication and other types of card technologies. They also showed me their NFC cards with LED lights. They lit up when the card was placed near the reader. LED cards draw power from RF field. They printed one of these cards with my choice of photo and gave it to me as a gift.

I quite like the LED lights in the card. They serve as confirmation that the reader has successfully scanned the card. It is a nice feature that is missing in normal NFC cards where there is no visual clue if the card has been scanned successfully.

However, the gifted card was blank and nothing happened when I scanned it using my phone aside from lighting up!
Having played around with some NFC tags in the past, I tried to use [NFC TagWriter](https://play.google.com/store/apps/details?id=com.nxp.nfc.tagwriter&hl=en&pli=1) to write data to the card.
But soon, I realised it was not possible as the card was using a different technology called **MIFARE Classic** (one of the older contactless smartcard families from NXP, built on 13.56 MHz ISO 14443-A).

So I dug in!

## Introducing the MIFARE Classic card

Unlike common NFC tags, MIFARE Classic cards are more secure and can store more data than typical NFC tags. They are also more expensive to produce but offer better security and reliability.

MIFARE Classic cards are divided into sectors, each containing four blocks of data. Each block can hold up to 16 bytes of data. The last block of each sector is reserved for authentication and access control.

Most MIFARE Classic cards fall into two groups:

* 1K (16 sectors × 4 blocks per sector)
* 4K (more sectors, a bit more chaotic, but same idea)

Using [NFC Tools](https://play.google.com/store/apps/details?id=com.wakdev.wdnfc), I learned my gifted card is 1K.

Under the hood, a MIFARE Classic isn’t a “smart card” in the modern sense. Think of it more like a tiny EEPROM with a basic access-control wrapper. You read or write chunks of memory, but you must authenticate first using a sector key — either Key A or Key B.

To write data to a MIFARE Classic card, you need to authenticate with the card using a key. Once authenticated, you can write data to the card using the MIFARE Classic protocol.

### Secret Keys

Every sector on a MIFARE Classic card has two keys:

* Key A – traditionally used as the “reader” key
* Key B – often used as the “writer/admin” key

Plus an Access Bits field controlling what each key is allowed to do.

These keys aren’t stored somewhere special; they’re literally sitting in the card’s memory, inside a reserved block called the **Sector Trailer**. Both keys and the access bits live in this trailer. The keys never leave the card, and you authenticate against them before the card will let you touch the rest of the sector.

### Memory Layout

Each sector contains **4 blocks**, and each block is **16 bytes**.

* **Block 0** – Data (in Sector 0 Block 0, this is manufacturer info and UID: read-only)
* **Block 1** – Data
* **Block 2** – Data
* **Block 3** – Sector Trailer (Keys + Access Bits)

```

Sector 0
├─ Block 0: UID + manufacturer data (read-only)
├─ Block 1: Data (16 bytes)
├─ Block 2: Data (16 bytes)
└─ Block 3: Sector Trailer [Key A | Access Bits | Key B]

Sector 1
├─ Block 0: Data
├─ Block 1: Data
├─ Block 2: Data
└─ Block 3: Sector Trailer

...
Sector 15
├─ Block 0: Data
├─ Block 1: Data
├─ Block 2: Data
└─ Block 3: Sector Trailer

````

## Hack a MIFARE Classic into an NFC Tag

To hack a MIFARE Classic card into an electronic business card, we need to:

1. Find a phone that can read MIFARE Classic cards (e.g. Pixel supports. iPhone doesn't)
2. Find an app that lets us read and write to MIFARE Classic cards
3. Authenticate using a sector key
4. Write a tiny NDEF-like payload (e.g. URL record) into any writable block

After understanding my gifted card’s technology, I looked for an app that could let me read and write to MIFARE Classic and found [MIFARE Classic Tool](https://github.com/ikarus23/MifareClassicTool).

Next, I needed to find the keys.
Thankfully, the card used default keys (`FFFFFFFFFFFF`) so it was trivial to authenticate and read the existing memory layout.

*It is also possible to brute-force keys, but that is beyond the scope of this article.*

### What is NDEF?

The protocol behind “an NFC card that opens a LinkedIn profile” is **NDEF** — the **NFC Data Exchange Format**. Think of NDEF as the universal “language” NFC devices speak when they want to store or read meaningful data.

NDEF is basically a tiny, structured envelope for data.
Inside that envelope you can put:

* a URL (e.g. LinkedIn profile link)
* a text record
* a phone number
* a vCard
* or pretty much anything else NFC devices understand

Every NFC-compliant tag and every modern phone knows how to interpret these envelopes. That’s why when you tap a normal NFC business card on a phone, it instantly knows “oh, that’s a URL — launch it.”

### MIFARE Classic is older than NDEF

MIFARE Classic wasn’t originally designed to use NDEF.
It predates the NFC Forum standards, so Classic cards are basically raw memory with access control.
By default, they cannot be used as NFC tags.

Even though Classic doesn't natively support NDEF, phones that can read Classic memory still look for NDEF patterns. If they find one, they treat the card like a normal NFC tag.

So if you want a MIFARE Classic card to behave like a modern NFC tag, you need to **store your data in NDEF format inside the Classic’s memory**.

### Writing a URL to a MIFARE Classic

To write a URL record into a MIFARE Classic card, you need to follow the NDEF format:

* NDEF TLV header
* URL payload
* Terminator TLV

```text
+-----------------------------+
| TLV Type (0x03)             |
+-----------------------------+
| TLV Length (NDEF size)      |
+-----------------------------+
| NDEF Message                |
|   +----------------------+  |
|   | NDEF Header (D1...)  |  |
|   +----------------------+  |
|   | Type ("U")           |  |
|   +----------------------+  |
|   | Payload Length       |  |
|   +----------------------+  |
|   | Payload (URL etc.)   |  |
|   +----------------------+  |
+-----------------------------+
| Terminator TLV (0xFE)       |
+-----------------------------+
```

For example, a URL in this format looks like: `03 XX D1 01 YY 55 ZZ ... FE`

Where:

* `03` – TLV type for NDEF
* `XX` – Length of NDEF payload
* `D1` – NDEF header
* `01` – Length of the record
* `YY` – Payload size
* `55` – URI prefix identifier
* `ZZ ...` – Your URL, encoded
* `FE` – Terminator

Phones look for this pattern inside the first few sectors, and if they see something valid, they’ll launch the URL automatically.

Putting this all together, this is a complete NDEF dump that opens `https://pedramhayati.com`:

```text
03 15
D1 01 11 55 04
70 65 64 72 61 6D 68 61 79 61 74 69 2E 63 6F 6D
FE
````

Let’s break it down.

```
03 15
│  └─ Length of the NDEF message: 0x15 = 21 bytes
└──── NDEF Message TLV (0x03)
```

After those two bytes comes the NDEF message itself.

```
FE = Terminator TLV
```

This tells the NFC reader “no more data”.

The NDEF message inside the TLV is exactly 21 bytes:

```text
D1 01 11 55 04
70 65 64 72 61 6D 68 61 79 61 74 69 2E 63 6F 6D
```

| Bytes | Meaning                                      |
| ----- | -------------------------------------------- |
| `D1`  | MB=1, ME=1, SR=1, TNF=0x01 (Well-Known Type) |
| `01`  | Type Length = 1 (the `"U"` type)             |
| `11`  | Payload Length = 17 bytes                    |
| `55`  | Type `"U"` → URI Record                      |
| `04`  | URI prefix: `https://`                       |

Payload is ASCII for `pedramhayati.com`:

```
70 65 64 72 61 6D 68 61 79 61 74 69 2E 63 6F 6D
p  e  d  r  a  m  h  a  y  a  t  i  .  c  o  m
```

*To change the URL, you need to hex-encode your domain name, place it in the payload and update the Length field (your domain + 1).*

## Step-by-Step Hacking Process

Open MIFARE Classic Tool, and select “Read Tag”.

![Mifare Class Tool](/blog/images/mct-mainpage.webp)

Tick “extended-std.keys” and “std.keys”. These are two files that contain a list of default keys. Place the card next to your phone’s NFC reader and click “Start mapping and read tag”.

After a few seconds you will see the memory dump of the card.

![Memory dump of NDEF record](/blog/images/mct-ph-dump.png)

Click on the three-dots menu (top right corner) and select “Export”.
Save the dump as `.mct`. Keep this as your backup.

Next, we are going to write an NDEF record. You can first try to write an empty NDEF record.
Download [this empty NDEF layout dump](/blog/attachments/NDEF.mct), go to “Tools”, and select “Import/Export/Convert file”.
Click on “Import Dump” and select the downloaded file.

Next go to “Write Tag”, select “Write Dump (Clone)”, then select the dump file.
Select all sectors (you should skip Sector 0 for most cards), put the card next to your phone’s NFC reader and click “OK”.

![MCT Write Dump](/blog/images/mct-write.webp)

Your card is now an NFC tag with empty content. You can use TagWriter to read its content.

Next, we are going to write an NDEF record with a URL. You can either modify the downloaded file, replace Sector 1 with your URL, and rewrite it, or you can write the NDEF record directly on the card using “Write Block”. In both cases you need to ensure each block is 16 bytes.
You can use `00` to fill the remaining bytes.

```text
03 15 D1 01 11 55 04 70 65 64 72 61 6D 68 61 79  - BLOCK 0
61 74 69 2E 63 6F 6D FE 00 00 00 00 00 00 00 00  - BLOCK 1
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  - BLOCK 2
```

To use “Write Block”, if you have previously used the downloaded empty dump, you only need to overwrite the content of Block 1 and Block 2.
Click on “Write Tag”, enter **1** in the Sector field and **0** in the Block field. Enter the following in the Data field:

```text
03 15 D1 01 11 55 04 70 65 64 72 61 6D 68 61 79
```

Place the card next to your phone’s NFC reader and click “Write Block”.

Next, enter **1** in the Sector field and **1** in the Block field. Enter:

```text
61 74 69 2E 63 6F 6D FE 00 00 00 00 00 00 00 00
```

Place the card next to your phone’s NFC reader and click “Write Block”.

All done! You now have a MIFARE Classic card with a URL NDEF record.

Exit the app. Point the card at your phone’s NFC reader and `https://pedramhayati.com` will open in your browser.

![My business card with LED](/blog/images/nfc-business-card-with-led.gif)

Happy hacking!
