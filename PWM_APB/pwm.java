import java.util.*; 

class pwm { 
    public static void main(String args[]) { 
        Scanner sc = new Scanner(System.in); 
        double time = Math.pow(10, -7); 
        
        System.out.print("Enter the frequency (Hz): "); 
        double freq = sc.nextDouble(); 
        
        System.out.print("Enter the Duty cycle (0-100): "); 
        double duty_cycle = sc.nextDouble(); 
        
        double temp = 1.0 / freq; 
        double periodVal = temp / time; 
        double dutyVal = (duty_cycle / 100.0) * periodVal; 
        
        // Convert to integers and apply bit masks to fit specific bit sizes
        // Masking with 0xFFFF ensures the value fits exactly into 16 bits (max 65535)
        int periodBits = ((int) periodVal) & 0xFFFF;
        int dutyBits = ((int) dutyVal) & 0xFFFF;
        
        // Pack into a 32-bit RISC-V register layout:
        // Bits [31:16] (16 bits) -> Period
        // Bits [15:0]  (16 bits) -> Duty
        int riscv_register = (periodBits << 16) | dutyBits;
        
        // Outputs
        System.out.printf("\nCalculated Period: %.2f (Bit representation: %d)\n", periodVal, periodBits); 
        System.out.printf("Calculated Duty: %.2f (Bit representation: %d)\n", dutyVal, dutyBits); 
        
        // Display register in Hexadecimal and Binary formats
        System.out.printf("RISC-V Register Value (Hex): 0x%08X\n", riscv_register);
        System.out.printf("RISC-V Register Value (Binary): %32s\n", Integer.toBinaryString(riscv_register).replace(' ', '0'));
    } 
}
