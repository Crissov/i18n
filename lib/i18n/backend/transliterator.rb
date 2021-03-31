# encoding: utf-8
# frozen_string_literal: true

module I18n
  module Backend
    module Transliterator
      DEFAULT_REPLACEMENT_CHAR = "?"

      # Given a locale and a UTF-8 string, return the locale's ASCII
      # approximation for the string.
      def transliterate(locale, string, replacement = nil)
        @transliterators ||= {}
        @transliterators[locale] ||= Transliterator.get I18n.t(:'i18n.transliterate.rule',
          :locale => locale, :resolve => false, :default => {})
        @transliterators[locale].transliterate(string, replacement)
      end

      # Get a transliterator instance.
      def self.get(rule = nil)
        if !rule || rule.kind_of?(Hash)
          HashTransliterator.new(rule)
        elsif rule.kind_of? Proc
          ProcTransliterator.new(rule)
        else
          raise I18n::ArgumentError, "Transliteration rule must be a proc or a hash."
        end
      end

      # A transliterator which accepts a Proc as its transliteration rule.
      class ProcTransliterator
        def initialize(rule)
          @rule = rule
        end

        def transliterate(string, replacement = nil)
          @rule.call(string)
        end
      end

      # A transliterator which accepts a Hash of characters as its translation
      # rule.
      class HashTransliterator
        DEFAULT_APPROXIMATIONS = {
          # A
          "Á"=>"A", "À"=>"A", "Â"=>"A", "Ã"=>"A", "Ă"=>"A", "Ā"=>"A", "Ä"=>"A", "Å"=>"A", "Ą"=>"A", 
          "á"=>"a", "à"=>"a", "â"=>"a", "ã"=>"a", "ă"=>"a", "ā"=>"a", "ä"=>"a", "å"=>"a", "ą"=>"a", 
          "Æ"=>"AE",
          "æ"=>"ae", 
          # B
          # C
          "Ć"=>"C", "Ĉ"=>"C", "Č"=>"C", "Ċ"=>"C", "Ç"=>"C", 
          "ć"=>"c", "ĉ"=>"c", "č"=>"c", "ċ"=>"c", "ç"=>"c", 
          # D
          "Ď"=>"D", "Đ"=>"D", "Ð"=>"D", 
          "ď"=>"d", "đ"=>"d", "ð"=>"d",
          # E
          "É"=>"E", "È"=>"E", "Ê"=>"E", "Ě"=>"E", "Ĕ"=>"E", "Ē"=>"E", "Ë"=>"E", "Ė"=>"E", "Ę"=>"E",
          "é"=>"e", "è"=>"e", "ê"=>"e", "ě"=>"e", "ĕ"=>"e", "ē"=>"e", "ë"=>"e", "ė"=>"e", "ę"=>"e",
          # F
          # G
          "Ĝ"=>"G", "Ğ"=>"G", "Ġ"=>"G", "Ģ"=>"G",
          "ĝ"=>"g", "ğ"=>"g", "ġ"=>"g", "ģ"=>"g", 
          # H
          "Ĥ"=>"H", "Ħ"=>"H", 
          "ĥ"=>"h", "ħ"=>"h", 
          # I
          "Í"=>"I", "Ì"=>"I", "Î"=>"I", "Ĩ"=>"I", "Ĭ"=>"I", "Ī"=>"I", "Ï"=>"I", "İ"=>"I", "Į"=>"I", 
          "í"=>"i", "ì"=>"i", "î"=>"i", "ĩ"=>"i", "ĭ"=>"i", "ī"=>"i", "ï"=>"i", "ı"=>"i", "į"=>"i", 
          "Ĳ"=>"IJ", 
          "ĳ"=>"ij", 
          # J
          "Ĵ"=>"J", 
          "ĵ"=>"j", 
          # K
          "Ķ"=>"K", 
          "ķ"=>"k", "ĸ"=>"k", 
          # L
          "Ĺ"=>"L", "Ľ"=>"L", "Ł"=>"L", "Ŀ"=>"L", "Ļ"=>"L", 
          "ĺ"=>"l", "ľ"=>"l", "ł"=>"l", "ŀ"=>"l", "ļ"=>"l", 
          # M
          # N
          "Ń"=>"N", "Ñ"=>"N", "Ň"=>"N", "Ņ"=>"N",
          "ń"=>"n", "ñ"=>"n", "ň"=>"n", "ņ"=>"n", 
          "Ŋ"=>"NG", 
          "ŋ"=>"ng",
          "ŉ"=>"'n", 
          # O
          "Ó"=>"O", "Ò"=>"O", "Ô"=>"O", "Õ"=>"O", "Ŏ"=>"O", "Ő"=>"O", "Ō"=>"O", "Ö"=>"O", "Ø"=>"O", 
          "ó"=>"o", "ò"=>"o", "ô"=>"o", "õ"=>"o", "ŏ"=>"o", "ő"=>"o", "ō"=>"o", "ö"=>"o", "ø"=>"o", 
          "Œ"=>"OE",
          "œ"=>"oe", 
          # P
          # Q
          # R
          "Ŕ"=>"R", "Ř"=>"R", "Ŗ"=>"R", 
          "ŕ"=>"r", "ř"=>"r", "ŗ"=>"r", 
          # S
          "Ś"=>"S", "Ŝ"=>"S", "Š"=>"S", "Ş"=>"S", 
          "ś"=>"s", "ŝ"=>"s", "š"=>"s", "ş"=>"s", 
          "ß"=>"ss", 
          # T
          "Ť"=>"T", "Ŧ"=>"T", "Ţ"=>"T", 
          "ť"=>"t", "ŧ"=>"t", "ţ"=>"t", 
          "Þ"=>"Th", 
          "þ"=>"th",
          # U
          "Ú"=>"U", "Ù"=>"U", "Û"=>"U", "Ũ"=>"U", "Ŭ"=>"U", "Ű"=>"U", "Ū"=>"U", "Ü"=>"U", "Ů"=>"U", "Ų"=>"U", 
          "ú"=>"u", "ù"=>"u", "û"=>"u", "ũ"=>"u", "ŭ"=>"u", "ű"=>"u", "ū"=>"u", "ü"=>"u", "ů"=>"u", "ų"=>"u", 
          # V
          # W
          "Ŵ"=>"W", 
          "ŵ"=>"w",
          # X
          "×"=>"x", 
          # Y
          "Ý"=>"Y", "Ŷ"=>"Y", "Ÿ"=>"Y",
          "ý"=>"y", "ŷ"=>"y", "ÿ"=>"y", 
          # Z
          "Ź"=>"Z", "Ž"=>"Z", "Ż"=>"Z", 
          "ź"=>"z", "ž"=>"z", "ż"=>"z"
        }.freeze

        def initialize(rule = nil)
          @rule = rule
          add_default_approximations
          add rule if rule
        end

        def transliterate(string, replacement = nil)
          replacement ||= DEFAULT_REPLACEMENT_CHAR
          string.gsub(/[^\x00-\x7f]/u) do |char|
            approximations[char] || replacement
          end
        end

        private

        def approximations
          @approximations ||= {}
        end

        def add_default_approximations
          DEFAULT_APPROXIMATIONS.each do |key, value|
            approximations[key] = value
          end
        end

        # Add transliteration rules to the approximations hash.
        def add(hash)
          hash.each do |key, value|
            approximations[key.to_s] = value.to_s
          end
        end
      end
    end
  end
end
