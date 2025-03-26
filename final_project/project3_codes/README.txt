new_contol_unit kullanıldı. control_unit de base selection yoktu onu ekledim sonra B = 0 ekledim ve  A = 0 için düzenleme yaptım
new_control_unitte de yeni diye düzenleme yaptım. 
Önemli olan şey in_mux_add ve reg_add ile seçince 1 clk sonra register çıkışına işleniyor. in_mux_add ve reg_add ile aynı state de insel yaparsan
register çıkışında olan eski veriyi alıyor. 
out_mux_add de böyle sıkıntı yok o zaten çıkışta olan veriyi veriyor registerdan veri geçirmeyi beklemiyor yani insel ile aynı state de olabilir 