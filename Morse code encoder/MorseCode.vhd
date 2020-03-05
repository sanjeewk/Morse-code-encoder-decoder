library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MorseDecoder is
	Port (
		ain  : in STD_LOGIC_VECTOR (11 downto 0);
		clk  : in STD_LOGIC;
		clr  : in STD_LOGIC;
		sout : out STD_LOGIC);
	end MorseDecoder;
	
architecture final of MorseDecoder is
	component au2mc
	    Port ( 
			ain     : in  STD_LOGIC_VECTOR (11 downto 0);
			d_bin   : out STD_LOGIC;
			clk_48k : in  STD_LOGIC;
			clr     : in  STD_LOGIC);
	end component;
	
	component symdet
	    Port (
			d_bin : in  STD_LOGIC;
			dot   : out STD_LOGIC;
			dash  : out STD_LOGIC;
			lg 	  : out STD_LOGIC;
			wg 	  : out STD_LOGIC;
			valid : out STD_LOGIC;
			clr   : in  STD_LOGIC;
			clk   : in  STD_LOGIC);
	end component;
	
	component mcdecoder
	    Port (
			dot 	: in  STD_LOGIC;
			dash 	: in  STD_LOGIC;
			lg 		: in  STD_LOGIC;
			wg 		: in  STD_LOGIC;
			valid 	: in  STD_LOGIC;
			dout 	: out STD_LOGIC_VECTOR (7 downto 0);
			dvalid	: out STD_LOGIC;	
			error	: out STD_LOGIC;
			clr 	: in  STD_LOGIC;
			clk 	: in  STD_LOGIC);	
	end component;
	
	component uart_wren
		Port ( 
           clr      : in  std_logic;
           clk      : in  STD_LOGIC;
           wr_valid : in  STD_LOGIC;
           dout     : out STD_LOGIC;
           data_in  : in  std_logic_vector(7 downto 0);
           data_out : out std_logic_vector(7 downto 0));
	end component;
	
	component simpuart
	    Port ( 
           din     : in  STD_LOGIC_VECTOR (7 downto 0);
           wen     : in  STD_LOGIC;
           sout    : out STD_LOGIC;
           clr     : in  STD_LOGIC;
           clk_48k : in  STD_LOGIC);
	end component;
	

	signal as_d_bin : STD_LOGIC;
	
	signal sm_dot	: STD_LOGIC;
	signal sm_dash	: STD_LOGIC;
	signal sm_lg	: STD_LOGIC;
	signal sm_wg	: STD_LOGIC;
	signal sm_valid : STD_LOGIC;


	signal mu_data	 : STD_LOGIC_VECTOR (7 downto 0);
	signal mu_dvalid : STD_LOGIC;
	signal mu_error  : STD_LOGIC;
	
	signal us_data : STD_LOGIC_VECTOR (7 downto 0);
	signal us_en   : STD_LOGIC;
	
begin

	au2mc1 : au2mc PORT MAP (
		ain  => ain,
		d_bin => as_d_bin,
		clk_48k  => clk,
		clr  => clr);
	
	symdet1 : symdet PORT MAP (
		d_bin => as_d_bin,	--: in  STD_LOGIC;
		dot   => sm_dot,	--: out STD_LOGIC;
		dash  => sm_dash,	--: out STD_LOGIC;
		lg 	  => sm_lg,		--: out STD_LOGIC;
		wg 	  => sm_wg,		--: out STD_LOGIC;
		valid => sm_valid,	--: out STD_LOGIC;
		clr   => clr,		--: in  STD_LOGIC;
		clk   => clk);		--: in  STD_LOGIC);
	
	mcdecoder1 : mcdecoder PORT MAP (
		dot 	=> sm_dot,		--: in  STD_LOGIC;
		dash 	=> sm_dash,		--: in  STD_LOGIC;
		lg 		=> sm_lg,		--: in  STD_LOGIC;
		wg 		=> sm_wg,		--: in  STD_LOGIC;
		valid 	=> sm_valid,	--: in  STD_LOGIC;
		dout 	=> mu_data,		--: out STD_LOGIC_VECTOR (7 downto 0);
		dvalid	=> mu_dvalid,	--: out STD_LOGIC;	
		error	=> mu_error,		--: out STD_LOGIC;
		clr 	=> clr,			--: in  STD_LOGIC;
		clk 	=> clk);			--: in  STD_LOGIC);			
		
	uart_wren1 : uart_wren PORT MAP (
        clr      => clr,		--: in  std_logic;
        clk      => clk,		--: in  STD_LOGIC;
        wr_valid => mu_dvalid,	--: in  STD_LOGIC;
        dout     => us_en,	--: out STD_LOGIC;
        data_in  => mu_data,	--: in  std_logic_vector(7 downto 0);
        data_out => us_data);	--: out std_logic_vector(7 downto 0));	
		
	simpuart1 : simpuart PORT MAP (
        din   	=> us_data,		--: in  STD_LOGIC_VECTOR (7 downto 0);
        wen     => us_en, 	--: in  STD_LOGIC;
        sout    => sout,		--: out STD_LOGIC;
        clr     => clr,			--: in  STD_LOGIC;
        clk_48k	=> clk);--: in  STD_LOGIC);

end final;
	
	