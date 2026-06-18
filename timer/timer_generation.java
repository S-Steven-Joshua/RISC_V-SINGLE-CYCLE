import java.util.Scanner;

/*
 * Builds a 32-bit timer control word from user input.
 *
 * Bit layout (data_word[31:0]):
 *   [15:0]  -> counter value (data). Only the lower `bitWidth` bits
 *              (per selected size) are meaningful; remaining upper
 *              bits within this field stay 0.
 *   [23:16] -> next counter value, ALWAYS strictly 8-bit (0-255),
 *              used only in NORMAL mode, independent of size.
 *   [25:24] -> mode select: 00 = normal, 01 = auto, 10 = square
 *   [26]    -> direction: 1 = forward, 0 = backward
 *   [28:27] -> size select: 00 = 4-bit, 01 = 8-bit, 10 = 12-bit, 11 = 16-bit
 *   [31:29] -> reserved / unused, always 0
 */
class Timer {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Select mode:");
        System.out.println("1 - Normal");
        System.out.println("2 - Normal Back");
        System.out.println("3 - Auto");
        System.out.println("4 - Auto Back");
        System.out.println("5 - Square");
        System.out.println("6 - Square Back");
        System.out.print("Enter choice (1-6): ");
        int choice = sc.nextInt();

        int modeBits;      // [25:24]
        int directionBit;  // [26]

        switch (choice) {
            case 1: modeBits = 0b00; directionBit = 1; break; // normal, forward
            case 2: modeBits = 0b00; directionBit = 0; break; // normal, backward
            case 3: modeBits = 0b01; directionBit = 1; break; // auto, forward
            case 4: modeBits = 0b01; directionBit = 0; break; // auto, backward
            case 5: modeBits = 0b10; directionBit = 1; break; // square, forward
            case 6: modeBits = 0b10; directionBit = 0; break; // square, backward
            default:
                System.out.println("Invalid choice. Exiting.");
                sc.close();
                return;
        }

        // Size must be known BEFORE the counter value, since the counter's
        // valid range (and how many of the 16 bits are "live") depends on it.
        System.out.println("Select size:");
        System.out.println("1 - 4 bit");
        System.out.println("2 - 8 bit");
        System.out.println("3 - 12 bit");
        System.out.println("4 - 16 bit");
        System.out.print("Enter choice (1-4): ");
        int sizeChoice = sc.nextInt();

        int sizeBits;   // [28:27]
        int bitWidth;   // actual counter width selected (4/8/12/16)
        switch (sizeChoice) {
            case 1: sizeBits = 0b00; bitWidth = 4;  break;
            case 2: sizeBits = 0b01; bitWidth = 8;  break;
            case 3: sizeBits = 0b10; bitWidth = 12; break;
            case 4: sizeBits = 0b11; bitWidth = 16; break;
            default:
                System.out.println("Invalid size choice. Exiting.");
                sc.close();
                return;
        }

        // The 16-bit field [15:0] holds the counter value, but only the
        // lower `bitWidth` bits are meaningful. The remaining upper bits
        // within the 16-bit field stay 0 (zero-padded) automatically as
        // long as the entered value fits within bitWidth.
        int counterMax = (1 << bitWidth) - 1;
        int counterValue = readInRange(sc, "Enter counter value (0-" + counterMax + " for " + bitWidth + "-bit size)", counterMax);

        // [23:16] is always a strict 8-bit field (0-255), only used in
        // normal mode. Unlike the main counter value, it does NOT depend
        // on the selected size.
        int nextCounterValue = 0;
        if (modeBits == 0b00) { // normal mode
            nextCounterValue = readInRange(sc, "Enter next counter value (0-255)", 255);
        }

        int dataWord = 0;
        dataWord |= (counterValue & 0xFFFF);          // [15:0]  (upper unused bits stay 0)
        dataWord |= (nextCounterValue & 0xFF) << 16;  // [23:16]
        dataWord |= (modeBits & 0x3) << 24;           // [25:24]
        dataWord |= (directionBit & 0x1) << 26;       // [26]
        dataWord |= (sizeBits & 0x3) << 27;           // [28:27]

        String binary = String.format("%32s", Integer.toBinaryString(dataWord)).replace(' ', '0');

        System.out.println("\nGenerated 32-bit control word:");
        System.out.println("Decimal       : " + dataWord);
        System.out.println("Hex           : 0x" + String.format("%08X", dataWord));
        System.out.println("Binary        : " + binary);
        System.out.println("SV hex literal: 32'h" + String.format("%08X", dataWord));

        System.out.println("\nField breakdown:");
        System.out.println("  [15:0]  counter value      = " + counterValue);
        System.out.println("  [23:16] next counter value = " + nextCounterValue);
        System.out.println("  [25:24] mode               = " + Integer.toBinaryString(modeBits | 0b100).substring(1));
        System.out.println("  [26]    direction          = " + directionBit + (directionBit == 1 ? " (forward)" : " (backward)"));
        System.out.println("  [28:27] size                = " + Integer.toBinaryString(sizeBits | 0b100).substring(1) + " (" + bitWidth + "-bit)");
        System.out.println("  [31:29] reserved           = 000");
        sc.close();
    }

    // Repeatedly prompts until the user enters a value within [0, max].
    private static int readInRange(Scanner sc, String prompt, int max) {
        int value;
        while (true) {
            System.out.print(prompt + ": ");
            value = sc.nextInt();
            if (value >= 0 && value <= max) {
                return value;
            }
            System.out.println("Value out of range, must be between 0 and " + max + ".");
        }
    }
}