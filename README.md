# Fpga_Gercek_Zamanli_Saat_VHDL

### Projenin Açıklaması

Fpga uart protokolü ile bilgisayarla haberleşecek. Uygulamada toplamda 3 komut olacak. Birinci komut fpganın saatini değiştirecek. İkinci komut fpgadaki saati bilgisayara gönderecek. Üçüncü komut ise bilgisayardan gelen saat verisini fpgada ayarlı olan saatten çıkarıp farkını bilgisayara gönderecek. Uart ile gönderilen komutlar ASCII formatındadır. Komutlar:

* **“S.”:** Fpga’daki gerçek zamanı bilgisayara “SXXXX”1 formatında gönderecek.
* **“SXXXX”[^1]:** Bilgisayardan gönderilen saati fpgadaki gerçek zaman saati olarak ayarlar. Cevap olarak aynı veri gönderilecek.

[^1]: Selam
