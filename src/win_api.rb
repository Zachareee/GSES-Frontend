# frozen_string_literal: true

require 'fiddle'
require 'fiddle/import'
require 'fiddle/types'

# A comment
module Win
  MAX_PATH = 260

  # File open dialog
  module FileOpen
    extend Fiddle::Importer

    dlload 'Comdlg32'

    Openfilename = struct [
      'unsigned long lStructSize',
      'void* hwndOwner',
      'void* hInstance',
      'void* lpstrFilter',
      'void* lpstrCustomFilter',
      'unsigned long nMaxCustFilter',
      'unsigned long nFilterIndex',
      'void* lpstrFile',
      'unsigned long nMaxFile',
      'void* lpstrFileTitle',
      'unsigned long nMaxFileTitle',
      'void* lpstrInitialDir',
      'void* lpstrTitle',
      'unsigned long Flags',
      'unsigned short nFileOffset',
      'unsigned short nFileExtension',
      'void* lpstrDefExt',
      'void* lCustData',
      'void* lpfnHook',
      'void* lpTemplateName',
      'void* pvReserved',
      'unsigned long dwReserved',
      'unsigned long FlagsEx'
    ]

    extern 'bool GetOpenFileNameA(void* unnamedParam1)'
  end
end

# Native Dialog for user implementation
class NativeDialog
  include Win

  module Flags
    OFN_ALLOWMULTISELECT = 0x00000200
    OFN_CREATEPROMPT = 0x00002000
    OFN_DONTADDTORECENT = 0x02000000
    OFN_ENABLEHOOK = 0x00000020
    OFN_ENABLEINCLUDENOTIFY = 0x00400000
    OFN_ENABLESIZING = 0x00800000
    OFN_ENABLETEMPLATE = 0x00000040
    OFN_ENABLETEMPLATEHANDLE = 0x00000080
    OFN_EXPLORER = 0x00080000
    OFN_EXTENSIONDIFFERENT = 0x00000400
    OFN_FILEMUSTEXIST = 0x00001000
    OFN_FORCESHOWHIDDEN = 0x10000000
    OFN_HIDEREADONLY = 0x00000004
    OFN_LONGNAMES = 0x00200000
    OFN_NOCHANGEDIR = 0x00000008
    OFN_NODEREFERENCELINKS = 0x00100000
    OFN_NOLONGNAMES = 0x00040000
    OFN_NONETWORKBUTTON = 0x00020000
    OFN_NOREADONLYRETURN = 0x00008000
    OFN_NOTESTFILECREATE = 0x00010000
    OFN_NOVALIDATE = 0x00000100
    OFN_OVERWRITEPROMPT = 0x00000002
    OFN_PATHMUSTEXIST = 0x00000800
    OFN_READONLY = 0x00000001
    OFN_SHAREAWARE = 0x00004000
    OFN_SHOWHELP = 0x00000010
  end

  def initialize(title = nil)
    @instance = FileOpen::Openfilename.malloc
    @instance.lStructSize = Fiddle::Pointer[@instance].size
    @instance.lpstrTitle = title unless title.nil?
    @instance.lpstrFile = Fiddle::Pointer.malloc MAX_PATH * 2
    @instance.nMaxFile = MAX_PATH
  end

  def filters(filters)
    raise 'Expected Hash' unless filters.instance_of?(Hash)
    raise 'Keys must be strings' if filters.any? { |key, _value| !key.instance_of? String }

    f = "#{filters.to_a.map { |kvpair| kvpair.join "\0" }.join("\0")}\0\0"
    @instance.lpstrFilter = f
    self
  end

  def flags(flag)
    @instance.Flags = flag
  end

  def open_file
    Win::FileOpen.GetOpenFileNameA @instance
  end

  def selected_file
    @instance.lpstrFile
  end
end
