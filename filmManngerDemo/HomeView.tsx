import React, { useRef } from 'react';
import { Roll, Photo, store } from '../store';
import { Canister } from '../components/ui/Canister';
import { SketchButton } from '../components/ui/SketchButton';
import { Camera, Plus, Info } from 'lucide-react';

export const HomeView: React.FC<{ 
  onSelect: (id: string) => void;
  onOpenAbout: () => void;
  onCreateNew: (files: File[]) => void;
}> = ({ onSelect, onOpenAbout, onCreateNew }) => {
  const [rolls, setRolls] = React.useState<Roll[]>(store.getRolls());
  const fileInputRef = useRef<HTMLInputElement>(null);

  React.useEffect(() => {
    return store.subscribe(() => setRolls(store.getRolls()));
  }, []);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      const files = Array.from(e.target.files as FileList) as File[];
      onCreateNew(files);
      
      // Reset input
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const triggerUpload = () => fileInputRef.current?.click();

  return (
    <div className="p-8 max-w-5xl mx-auto min-h-screen flex flex-col">
      <header className="flex justify-between items-center mb-12 pb-4 border-b-2 border-ink border-dashed">
        <div>
          <h1 className="text-4xl font-bold flex items-center gap-3 font-marker mb-1">
            <Camera className="w-8 h-8" />
            昨日重现
            <button onClick={onOpenAbout} className="ml-2 mt-1 text-ink/30 hover:text-ink/80 transition-colors" title="关于 / About">
              <Info className="w-5 h-5" />
            </button>
          </h1>
          <p className="text-sm font-hand text-ink/60 italic ml-11">Yesterday Once More</p>
        </div>
        <SketchButton onClick={triggerUpload} className="gap-2 font-marker font-bold text-lg">
          <Plus className="w-5 h-5" />
          冲洗新胶卷
        </SketchButton>
        <input 
          type="file" 
          multiple 
          accept="image/*" 
          className="hidden" 
          ref={fileInputRef}
          onChange={handleFileChange}
        />
      </header>
      
      {rolls.length === 0 ? (
        <div className="flex-1 flex flex-col items-center justify-center opacity-70">
          <svg className="w-32 h-32 mb-6 text-ink/40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1" strokeLinecap="round" strokeLinejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
            <circle cx="8.5" cy="8.5" r="1.5"/>
            <polyline points="21 15 16 10 5 21"/>
          </svg>
          <p className="text-2xl font-marker text-ink/70 rotate-[-2deg]">桌面空空如也，冲洗一卷，重现昨日的记忆吧！</p>
          <div className="mt-8">
            <svg width="60" height="60" viewBox="0 0 100 100" className="opacity-50 rotate-[-10deg]">
              <path d="M50 10 L80 40 L50 70 M80 40 L20 40" stroke="currentColor" strokeWidth="4" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-8">
          {rolls.map(roll => (
            <Canister 
              key={roll.id} 
              label={roll.name} 
              type={roll.type}
              onClick={() => onSelect(roll.id)} 
            />
          ))}
        </div>
      )}
    </div>
  );
};
