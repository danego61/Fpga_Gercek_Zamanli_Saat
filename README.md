# Fpga_Gercek_Zamanli_Saat_VHDL

[Youtube video](https://www.youtube.com/watch?v=QN6cdpSawGo)

### Blok Diyagramı

![Blok Diyagramı](https://github.com/danego61/Fpga_Gercek_Zamanli_Saat_VHDL/blob/main/blok_diyagram%C4%B1.PNG)

### Projenin Açıklaması

Fpga uart protokolü ile bilgisayarla haberleşecek. Uygulamada toplamda 3 komut olacak. Birinci komut fpganın saatini değiştirecek. İkinci komut fpgadaki saati bilgisayara gönderecek. Üçüncü komut ise bilgisayardan gelen saat verisini fpgada ayarlı olan saatten çıkarıp farkını bilgisayara gönderecek. Uart ile gönderilen komutlar ASCII formatındadır. Komutlar:

* **“S.”:** Fpga’daki gerçek zamanı bilgisayara “SXXXX”<sup>1</sup> formatında gönderecek.
* **“SXXXX”:<sup>1</sup>** Bilgisayardan gönderilen saati fpgadaki gerçek zaman saati olarak ayarlar. Cevap olarak aynı veri gönderilecek.
* **“FXXXX”:<sup>1</sup>** Bilgisayardan gönderilen saatin FPGA’daki gerçek zaman saatinden farkını alıp gönderecek. Cevap olarak “+XXXX”<sup>1</sup> veya “-XXXX”<sup>1</sup> gönderilir. Eğer + ise gönderilen saatin şimdiki saatten önde olduğu, eksi ise geride olduğu anlamına gelir.

**1:** “XXXX” ile belirtilen baştan iki basamak 0-23 aralığında saat bilgisini sondaki iki basamak ise 0-59 aralığında dakika bilgisini göstermektedir.
