/*
模块功能：
将一个输入的脉冲信号Id_IqDonePulse，的高电平持续时间可以通过参数PULSE_WIDTH进行配置。
输出的脉冲信号两个相邻上升沿的距离可以通过count1来表示出来。
*/
module PulseGenerator (
    input  CLK,  
	 input nRESET,
    input  Id_IqDonePulse,   
    output reg pulse_out,
	 output reg [15:0] count1          
);

reg [15:0] count;  
reg [15:0]count2;
reg pulse_active,pulse_outR; 


parameter [15:0] PULSE_WIDTH = 501; 

always @ (posedge CLK or negedge nRESET)
begin
	if(!nRESET)
		begin
			pulse_outR <= 0;
			count1 <= 0;
			count2 <= 0;
		end
		
	 else
		begin
			pulse_outR <= pulse_out;
			if(pulse_out && !pulse_outR)
				begin
					count1 <= count2;
					count2 <= 0;
				end
			else
				count2 <= count2 + 1;

				
		end


end

always @ (posedge CLK or negedge nRESET)
begin
	 if(!nRESET)
		begin
			pulse_out <= 0;
			count <= 0;
			pulse_active <= 0;

		end
		
	 else

		begin
		 if (Id_IqDonePulse) 
			begin
			  pulse_active <= 1'b1; 
			  count <= 0;           
			end
		 
		 if (pulse_active) 
			begin
			  if (count < PULSE_WIDTH - 1) 
					begin
						count <= count + 1; 
						pulse_out <= 1'b1;   
					end 
			  else
					begin
						pulse_active <= 1'b0; 
						pulse_out <= 1'b0;     
					end
			end 
		 else 
			  pulse_out <= 1'b0;  
		end
end

 
endmodule