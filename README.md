# MeowTM (Meow Teller Machine)

> **Banking with nine lives and sixteen bits.**

MeowTM is a colorful ATM simulator written in **16-bit x86 assembly**. It handles fictional banking operations for **Neko Chartered**, the bank of Shimmerwhere, using BIOS and DOS interrupts, masked PIN input, dynamic balances, and an unreasonable number of text colors.

Before Neko Chartered had polished interfaces and PawPay lived in every cat's pocket, there was a little terminal dispensing **Shimmers** at midnight on January 1, 1970.

<p align="center">
  <img width="1606" height="748" alt="image" src="https://github.com/user-attachments/assets/1d3c35fa-2ee1-458d-9705-206023d17087" alt="MeowTM welcome screen" width="600">
</p>

---

## The Shimmerwhere financial system

| Service | Role |
|---|---|
| **Neko Chartered** | The bank that holds each cat's account |
| **PawPay** | The digital wallet and payment service |
| **MeowTM** | The physical Meow Teller Machine |
| **Shimmers** | The official fictional currency |

MeowTM began as a university ATM assignment and was later reworked into a small artifact from the financial history of Shimmerwhere.

## Features

- Rainbow character-by-character welcome screen
- Neko Chartered card prompt
- Four-digit masked PIN authentication
- Balance inquiry with comma-formatted Shimmer balances
- Custom withdrawal amounts with insufficient-funds checks
- Deposits with input and 16-bit overflow protection
- Transfers to numeric account numbers
- Secondary PIN verification for transfers
- Dynamic balance updates after transactions
- DOS-style menus, cursor positioning, and timed messages
- An epoch-era boot date of `1970-01-01 12:00:00 AM`

## Built with

- **16-bit x86 assembly**
- MASM/TASM-style syntax
- BIOS video services through `INT 10h`
- DOS input/output services through `INT 21h`
- BIOS wait service through `INT 15h`
- Small memory model with a `100h` stack

No framework. No cloud. No backend. Just registers, interrupts, fictional money, and cats.

## How it works

```text
Insert Neko Chartered card
            │
            ▼
     Enter masked PIN
            │
            ▼
    ┌──── Main menu ────┐
    │                   │
    ├─ Check balance    │
    ├─ Withdraw         │
    ├─ Deposit          │
    ├─ Transfer         │
    └─ Exit             │
```

The balance is stored as an unsigned 16-bit value. Numeric text input is converted manually, transaction values are validated, and the updated balance is converted back into formatted text for display.

## Demo credentials

```text
Cardholder: Xayna
PIN: 4205
Starting balance: 25,000 Shimmers
```

These credentials and all displayed funds are fictional and exist only inside the simulator.

## Running the project

MeowTM targets a 16-bit DOS environment. You can assemble and run it with a compatible MASM/TASM workflow inside DOSBox or another suitable emulator.
The project was made on emu8086.

Assembler commands may differ depending on the environment. If your toolchain uses TASM or an educational 8086 emulator, create a DOS executable using its normal small-model build process.

## Project structure

```text
meowtm/
├── meowtm.asm    # Complete program, data, menus, validation, and transactions
└── README.md     # You are here
```

## Technical highlights

### Colored BIOS text

The welcome screen places and colors individual characters with BIOS video services instead of printing one ordinary DOS string.

### Masked authentication

PIN characters are read without echo and displayed as asterisks. Transfers request the PIN again before allowing the user to enter an amount.

### Manual number formatting

The program converts the word-sized balance into decimal digits, prints a thousands separator, and adds the `Shimmers` currency suffix.

### Overflow-aware deposits

Deposit parsing checks multiplication overflow while the number is being built. The final addition also checks the carry flag so the stored balance cannot silently wrap beyond the unsigned 16-bit range of `65,535`.

## Known limitations

- Data exists only for the current program session; there is no persistent storage.
- The PIN and cardholder are hardcoded demonstration values.
- Account numbers are validated as numeric input, but the current version accepts between 1 and 10 digits rather than requiring exactly 10.
- Zero-value withdrawals and transfers are not rejected yet.
- Some invalid-input messages say the session is terminated even when the program returns to a menu.
- This is an educational simulator, not real banking or security software.

## Planned improvements

- Require exactly ten digits for destination accounts
- Reject zero-value transactions
- Add limited PIN retries
- Make invalid-input messages match their actual navigation
- Add transaction receipts and history
- Create a PawPay transfer option
- Add screenshots or a short terminal GIF

## Origin

The original version was created for a university assembly-language project in January 2025. In 2026, it was cleaned, renamed, and adopted into the Xaynakive/Shimmerwhere universe as **MeowTM — the Meow Teller Machine**.

The date was reset to the Unix epoch because apparently this cat bank has existed since the beginning of computerized time.

---

<p align="center">
  <strong>Thank you for purring with us.</strong><br>
  <sub>A tiny financial artifact from Shimmerwhere, created by Xayna.</sub>
</p>
