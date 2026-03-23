<script setup>
import { ref } from 'vue'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

const selectedItem = ref(0)
const activeTab = ref('included')
const panelTab = ref('all')

const selectorItems = [
  { label: 'COMPANY NAME ONE', code: 'CODE1', sublabel: 'Jan 1–15, 2025', due: 'Due Jan 24, 2025', selected: true },
  { label: 'COMPANY NAME ONE', code: 'CODE1', sublabel: 'Jan 15–31, 2025', due: 'Due Jan 24, 2025' },
  { label: 'COMPANY NAME TWO', code: 'CODE2', sublabel: 'Jan 15–31, 2025 · 4 employees adjusted' },
  { label: 'COMPANY NAME THREE', code: 'CODE3', sublabel: '' },
  { label: 'COMPANY NAME FOUR', code: 'CODE4', sublabel: '' },
  { label: 'COMPANY NAME FIVE', code: 'CODE5', sublabel: '' },
]

const rows = [
  { name: 'USER NAME', id: '#ID000001', col1: '4,547.89', col1sub: '5 Items', col2: '5,432.01', col2sub: '3 Items', status: 'ACTIVE' },
  { name: 'USER NAME', id: '#ID000002', col1: '3,890.50', col1sub: '3 Items', col2: '6,300.75', col2sub: '2 Items', status: 'PART-TIME' },
  { name: 'USER NAME', id: '#ID000003', col1: '5,100.00', col1sub: '4 Items', col2: '5,600.00', col2sub: '3 Items', status: 'ACTIVE' },
  { name: 'USER NAME', id: '#ID000004', col1: '5,100.00', col1sub: '4 Items', col2: '5,600.00', col2sub: '3 Items', status: 'ACTIVE' },
  { name: 'USER NAME', id: '#ID000005', col1: '3,890.50', col1sub: '3 Items', col2: '6,300.75', col2sub: '2 Items', status: 'PART-TIME' },
  { name: 'USER NAME', id: '#ID000006', col1: '5,100.00', col1sub: '4 Items', col2: '5,600.00', col2sub: '3 Items', status: 'ACTIVE' },
]

const detailCards = [
  { title: 'ITEM TITLE', amount: '+ 0,000.00', name: 'CUSTOM NAME', code: 'CODE VALUE', note: 'NOTE PLACEHOLDER TEXT. SHOWS UP TO 2 LINES BEFORE TRUNCATION...' },
  { title: 'ITEM TITLE', amount: '– 0,000.00', name: 'CUSTOM NAME', code: 'CODE VALUE', note: 'NOTE PLACEHOLDER TEXT. SHOWS UP TO 2 LINES...' },
  { title: 'ITEM TITLE', amount: '+ 0,000.00', name: 'CUSTOM NAME', code: 'CODE VALUE', note: 'NOTE PLACEHOLDER TEXT...' },
]
</script>

<template>
  <div class="flex flex-col h-screen bg-gray-50 pl-16">

    <!-- SIDE NAV: fixed, 64px wide, full height -->
    <nav class="fixed left-0 top-0 w-16 h-screen bg-gray-900 flex flex-col items-center py-4 z-10">
      <div class="w-8 h-8 bg-gray-600 rounded mb-6 flex items-center justify-center text-xs text-gray-400">L</div>
      <div class="flex flex-col items-center gap-2 flex-1">
        <div class="w-10 h-10 rounded-lg bg-gray-700 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-300 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
      </div>
      <div class="w-8 h-8 rounded-full bg-gray-500 flex items-center justify-center text-xs text-gray-300">U</div>
    </nav>

    <!-- TOP BAR: back/title + inline stepper + action buttons -->
    <header class="h-[60px] bg-white border-b border-gray-200 flex items-center px-6 gap-4 shrink-0">
      <!-- Back + workflow name -->
      <div class="flex items-center gap-2 shrink-0">
        <div class="w-6 h-6 bg-gray-300 rounded-sm" />
        <div class="w-5 h-5 bg-gray-200 rounded-sm" />
        <span class="text-sm font-medium text-gray-900">WORKFLOW NAME</span>
      </div>

      <!-- Inline stepper -->
      <div class="flex items-center flex-1 justify-center">
        <template v-for="(step, i) in ['STEP ONE', 'STEP TWO', 'STEP THREE', 'STEP FOUR']" :key="i">
          <div class="flex items-center gap-1.5">
            <div
              class="w-5 h-5 rounded-full flex items-center justify-center text-xs font-semibold shrink-0"
              :class="i < 2 ? 'bg-gray-900 text-white' : 'border-2 border-gray-300 text-gray-400'"
            >{{ i + 1 }}</div>
            <span
              class="text-xs whitespace-nowrap"
              :class="i === 1 ? 'font-semibold text-gray-900' : i < 1 ? 'text-gray-500' : 'text-gray-400'"
            >{{ step }}</span>
          </div>
          <div v-if="i < 3" class="w-10 h-px mx-2" :class="i < 1 ? 'bg-gray-400' : 'bg-gray-200'" />
        </template>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-2 shrink-0">
        <Button variant="outline" class="h-8 text-xs">BACK</Button>
        <Button class="h-8 text-xs">NEXT →</Button>
      </div>
    </header>

    <!-- THREE-PANEL CONTENT: bento layout — gray background shows as gutter between floating cards -->
    <div class="flex flex-1 overflow-hidden bg-gray-100 p-3 gap-3">

      <!-- LEFT PANEL: floating card -->
      <aside class="w-[338px] bg-white rounded-xl shadow-sm flex flex-col overflow-y-auto shrink-0">
        <div class="p-4 flex-1">
          <p class="text-sm font-semibold text-gray-900 mb-0.5">SELECTOR CARD TITLE</p>
          <p class="text-xs text-gray-400 mb-3">SELECTOR DESCRIPTION PLACEHOLDER</p>

          <div class="flex items-center gap-2 border border-gray-300 rounded px-3 py-2 mb-3">
            <div class="w-4 h-4 bg-gray-300 rounded-sm" />
            <span class="text-xs text-gray-400 flex-1">SEARCH...</span>
            <div class="w-4 h-4 bg-gray-200 rounded-sm" />
          </div>

          <div class="space-y-0.5">
            <div
              v-for="(item, i) in selectorItems"
              :key="i"
              class="px-3 py-2 rounded cursor-pointer transition-colors"
              :class="i === selectedItem ? 'bg-gray-100 border-l-2 border-gray-900' : 'hover:bg-gray-50'"
              @click="selectedItem = i"
            >
              <div class="flex items-center justify-between">
                <p class="text-sm" :class="i === selectedItem ? 'font-medium text-gray-900' : 'text-gray-700'">{{ item.label }}</p>
                <span class="text-xs text-gray-500 border border-gray-200 rounded px-1.5 py-0.5">{{ item.code }}</span>
              </div>
              <p v-if="item.sublabel" class="text-xs text-gray-400 mt-0.5">{{ item.sublabel }}</p>
              <p v-if="item.due" class="text-xs text-gray-400">{{ item.due }}</p>
            </div>
          </div>
        </div>

        <!-- Bulk Upload -->
        <div class="p-4 border-t border-gray-100">
          <p class="text-sm font-semibold text-gray-900 mb-0.5">BULK UPLOAD TITLE</p>
          <p class="text-xs text-gray-400 mb-3">BULK UPLOAD DESCRIPTION PLACEHOLDER</p>
          <Button variant="outline" class="w-full h-8 text-xs mb-2">DOWNLOAD TEMPLATE</Button>
          <Button variant="outline" class="w-full h-8 text-xs">UPLOAD FILE</Button>
        </div>
      </aside>

      <!-- CENTER PANEL: floating card -->
      <main class="flex-1 flex flex-col overflow-hidden bg-white rounded-xl shadow-sm">

        <!-- Section header -->
        <div class="px-6 py-4 bg-white border-b border-gray-100 flex items-start justify-between shrink-0">
          <div>
            <h1 class="text-base font-semibold text-gray-900">TABLE SECTION TITLE</h1>
            <p class="text-xs text-gray-400 mt-0.5">TABLE SECTION DESCRIPTION PLACEHOLDER</p>
          </div>
          <Badge variant="outline" class="text-xs text-gray-600 border-gray-300">000/000 INCLUDED</Badge>
        </div>

        <!-- Table actions -->
        <div class="px-6 py-3 bg-white border-b border-gray-200 flex items-center gap-3 shrink-0">
          <Input placeholder="SEARCH..." class="h-8 text-xs max-w-xs" />
          <div class="w-8 h-8 border border-gray-300 rounded flex items-center justify-center">
            <div class="w-4 h-4 bg-gray-400 rounded-sm" />
          </div>
          <div class="flex-1" />
          <Button variant="outline" class="h-8 text-xs">BULK ACTION</Button>
          <Button class="h-8 text-xs">PRIMARY ACTION</Button>
        </div>

        <!-- Tabs -->
        <div class="px-6 bg-white border-b border-gray-200 flex gap-6 shrink-0">
          <button
            v-for="tab in [{ id: 'included', label: 'TAB ONE', count: '00' }, { id: 'excluded', label: 'TAB TWO', count: '00' }]"
            :key="tab.id"
            class="py-3 text-sm border-b-2 flex items-center gap-1.5 transition-colors"
            :class="activeTab === tab.id ? 'font-medium text-gray-900 border-gray-900' : 'text-gray-500 border-transparent'"
            @click="activeTab = tab.id"
          >
            {{ tab.label }}
            <span class="text-xs rounded-full px-1.5 py-0.5" :class="activeTab === tab.id ? 'bg-gray-900 text-white' : 'bg-gray-200 text-gray-600'">{{ tab.count }}</span>
          </button>
        </div>

        <!-- Table -->
        <div class="flex-1 overflow-y-auto bg-white">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead class="w-10 text-xs"><div class="w-4 h-4 border-2 border-gray-300 rounded" /></TableHead>
                <TableHead class="text-xs">EMPLOYEE NAME</TableHead>
                <TableHead class="text-xs">COLUMN ONE</TableHead>
                <TableHead class="text-xs">COLUMN TWO</TableHead>
                <TableHead class="text-xs">STATUS</TableHead>
                <TableHead class="w-20" />
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="(row, i) in rows" :key="i" class="cursor-pointer" @click="selectedItem = i">
                <TableCell><div class="w-4 h-4 border-2 border-gray-300 rounded" /></TableCell>
                <TableCell>
                  <p class="text-xs font-medium text-gray-900">{{ row.name }}</p>
                  <p class="text-xs text-gray-400">{{ row.id }}</p>
                </TableCell>
                <TableCell>
                  <p class="text-xs text-gray-700">{{ row.col1 }}</p>
                  <p class="text-xs text-gray-400">{{ row.col1sub }}</p>
                </TableCell>
                <TableCell>
                  <p class="text-xs text-gray-700">{{ row.col2 }}</p>
                  <p class="text-xs text-gray-400">{{ row.col2sub }}</p>
                </TableCell>
                <TableCell>
                  <Badge variant="outline" class="text-xs text-gray-600 border-gray-300">{{ row.status }}</Badge>
                </TableCell>
                <TableCell>
                  <div class="flex items-center gap-1">
                    <div class="w-7 h-7 rounded border border-gray-200 flex items-center justify-center"><div class="w-3 h-3 bg-gray-400 rounded-sm" /></div>
                    <div class="w-7 h-7 rounded border border-gray-200 flex items-center justify-center"><div class="w-3 h-3 bg-gray-400 rounded-sm" /></div>
                  </div>
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </div>

        <!-- Pagination -->
        <div class="bg-white border-t border-gray-200 px-6 py-3 flex items-center gap-4 shrink-0">
          <select class="border border-gray-300 rounded px-2 py-1 text-xs text-gray-600 bg-white">
            <option>10 Rows</option>
            <option>25 Rows</option>
          </select>
          <span class="text-xs text-gray-400 flex-1">1 – 10 of 000</span>
          <Button variant="outline" class="h-7 w-7 p-0"><div class="w-3 h-3 bg-gray-400 rounded-sm" /></Button>
          <Button variant="outline" class="h-7 w-7 p-0"><div class="w-3 h-3 bg-gray-400 rounded-sm" /></Button>
        </div>
      </main>

      <!-- RIGHT DETAIL PANEL: floating card -->
      <aside class="w-[400px] bg-white rounded-xl shadow-sm flex flex-col overflow-hidden shrink-0">

        <!-- Panel header -->
        <div class="px-5 py-4 border-b border-gray-200 flex items-center justify-between shrink-0">
          <h2 class="text-sm font-semibold text-gray-900">DETAIL PANEL TITLE</h2>
          <div class="w-7 h-7 flex items-center justify-center"><div class="w-4 h-4 bg-gray-300 rounded-sm" /></div>
        </div>

        <!-- Panel meta -->
        <div class="px-5 py-3 border-b border-gray-100 flex items-center justify-between shrink-0">
          <span class="text-xs text-gray-500">FIELD LABEL</span>
          <div class="flex items-center gap-2">
            <div class="w-4 h-4 bg-gray-200 rounded-sm" />
            <span class="text-xs font-medium text-gray-700">FIELD VALUE</span>
            <div class="w-3 h-3 bg-gray-300 rounded-sm" />
          </div>
        </div>

        <!-- Panel tabs -->
        <div class="px-5 border-b border-gray-200 flex gap-4 shrink-0">
          <button
            v-for="tab in ['all', 'additions', 'deductions']"
            :key="tab"
            class="py-3 text-sm border-b-2 capitalize transition-colors"
            :class="panelTab === tab ? 'font-medium text-gray-900 border-gray-900' : 'text-gray-500 border-transparent'"
            @click="panelTab = tab"
          >{{ tab.toUpperCase() }}</button>
        </div>

        <!-- Detail cards -->
        <div class="flex-1 overflow-y-auto px-5 py-4 space-y-3">
          <div v-for="(card, i) in detailCards" :key="i" class="border border-gray-200 rounded p-3 space-y-2">
            <div class="flex items-center justify-between">
              <p class="text-xs font-semibold text-gray-700">{{ card.title }}</p>
              <p class="text-xs text-gray-500">{{ card.amount }}</p>
            </div>
            <div class="flex items-center gap-1.5">
              <div class="w-3 h-3 bg-gray-200 rounded-sm" />
              <p class="text-xs text-gray-500">{{ card.name }}</p>
            </div>
            <div class="flex items-center gap-1.5">
              <div class="w-3 h-3 bg-gray-200 rounded-sm" />
              <p class="text-xs text-gray-500">{{ card.code }}</p>
            </div>
            <p class="text-xs text-gray-400 bg-gray-50 rounded p-2">{{ card.note }}</p>
            <div class="flex justify-end gap-2 pt-1">
              <div class="w-7 h-7 border border-gray-200 rounded flex items-center justify-center"><div class="w-3 h-3 bg-gray-400 rounded-sm" /></div>
              <div class="w-7 h-7 border border-gray-200 rounded flex items-center justify-center"><div class="w-3 h-3 bg-gray-400 rounded-sm" /></div>
            </div>
          </div>
        </div>

        <!-- Panel footer -->
        <div class="px-5 py-4 border-t border-gray-200 shrink-0">
          <Button class="w-full">ADD NEW</Button>
        </div>
      </aside>

    </div>
  </div>
</template>
