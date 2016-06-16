require 'color_echo';

def printhelp()
    puts "+---------------------------+";
    puts "|                           |";
    puts "| XXXXXXXXXXXXXXXXXXXXXXXXX |";
    puts "|X  ModVersionIncrimenter  X|";
    puts "| XXXXXXXXXXXXXXXXXXXXXXXXX |";
    puts "|                           |";
    puts "+---------------------------+";

    puts "まずbuild.gradleの中をそれぞれ下記の用に変更してください"
    puts "archivesBaseName = \"${mod_name}\"";
    puts "version = \"${mod_version}\"";
    puts;
    puts "そしてこのプログラムを起動するときの第一引数にMod作成フォルダのルートディレクトリを、"
    puts "第二引数に出力時のModの名前、";
    puts "第三引数にカウント最初の番号を入力してください。";
    puts "(二回目は入力しなくてもデータが作成されていればそこから読み込まれます)";
end

class Modbuild

@@mod_dir = ARGV[0] != nil ? ARGV[0].dup() : "";
@@mod_name = ARGV[1] != nil ? ARGV[1].dup() : "";
@@mod_version = ARGV[2] != nil ? ARGV[2].dup() : "";

def filewriteandread()
    if File.exist?(@@mod_name)
        @@mod_version = File.read(@@mod_name, :encoding => Encoding::UTF_8);
        print();
        File.open(@@mod_name,"w") do |file|
        file.write(VersionCount())
        end
    else
        puts @@mod_name + "用のファイルが存在しませんでした。新規作成します";
        print();
        File.open(@@mod_name,"w") do |file|
        file.write(@@mod_version)
        end
    end
end

def VersionCount()
    strAry = @@mod_version.split(".");
    major = strAry[0].to_i();
    minior = strAry[1].to_i();
    build = strAry[2].to_i();
    flag = true;

    if build == 9 then
        if minior == 9 then
            build = 0;
            minior = 0;
            major += 1;
            flag = false;
        end
        if flag then
        build = 0;
        minior += 1;
        flag = false;
        end
    end

    if flag then
        build += 1;
    end

    return major.to_s() << "." << minior.to_s() << "." << build.to_s();
end

def print()
    puts "適用されるModの名前: " << @@mod_name;
    puts "適用されるModバージョン: " << @@mod_version;
    puts "適用されるModのディレクトリ: "<< @@mod_dir;
end

def build()
system "chcp 65001 & cd "<< @@mod_dir << " & gradlew.bat build -Pmod_version=" << @@mod_version << " -Pmod_name=1.7.10-" << @@mod_name;
end
end


CE.fg(:cyan);
puts "ビルド開始";

if (ARGV[0] != nil && ARGV[0] != "--help") then
main = Modbuild.new();
main.filewriteandread();
main.build();
else
    printhelp();
    CE.fg(:red);
    puts "ビルドしたいMod作成フォルダのディレクトリをしてしてください";
    CE.fg(:white);
    exit(1);
end