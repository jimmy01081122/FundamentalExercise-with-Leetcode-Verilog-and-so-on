ref : https://ithelp.ithome.com.tw/m/articles/10344765
## function
```
function [return value位寬] name_of_function;
		input [位寬] 參數1,參數2,...;
		begin
			//function body
			name_of_function = 表達式;
		end
	endfunction
```
### function的限制 
1. 只能有一個輸出：也就是函數的return value，不得回傳void
2. 不能包含時間控制敘述：eg. delay、wait、@等、不能使用posedge和negedge。且function只能使用在組合邏輯，不能用在時序邏輯。
3. 只能使用「=」賦值。
4. 不能包含「<=」：「<=」只能在always或initial的區塊中使用。
5. 不能調用task，只能調用其他function。
6. 不能有內部靜態變量：function中的變量在每一次的呼叫都會重新初始化，不能保持靜態的狀態。
7. 不能包含輸入及輸出文件操作：文件操作非verilog語法的一部份，他屬於系統任務，所以不能在function內使用。
8. 必須在module內定義，不能在module外獨立定義 
9. 本身可被合成
## task

```
module ＿＿＿＿＿ ();
	// declare
	task name_of_task;
		input [位寬] 輸入參數1,輸入參數2,...;
		output [位寬] 輸出參數1, 輸出參數2,...;
		//宣告內部變量
	
		begin
			//task body
		end
	
	endtask
	//一些指令
endmodule
```
### task的限制
1. 可以有多個輸入、輸出及雙向端口。
2. 可以包含時間控制敘述，eg. delay、wait、@等。
3. 不能使用posedge和negedge。
4. 可以使用「=」及「<=」。
5. 可以調用其他task及function。
6. 作為語法調用，不能在表達式中使用。
7. 只能在module、interface、package中定義，不能在模塊外部獨立定義。
