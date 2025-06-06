<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportAthlete') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportAthleteTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-input v-model="sportAthleteTable.searchParam.member_id" :placeholder="t('memberIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('eventId')" prop="event_id">
                        <el-input v-model="sportAthleteTable.searchParam.event_id" :placeholder="t('eventIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('teamId')" prop="team_id">
                        <el-input v-model="sportAthleteTable.searchParam.team_id" :placeholder="t('teamIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportAthleteTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('gender')" prop="gender">
                        <el-input v-model="sportAthleteTable.searchParam.gender" :placeholder="t('genderPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('idCard')" prop="id_card">
                        <el-input v-model="sportAthleteTable.searchParam.id_card" :placeholder="t('idCardPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('phone')" prop="phone">
                        <el-input v-model="sportAthleteTable.searchParam.phone" :placeholder="t('phonePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('birthDate')" prop="birth_date">
                        <el-input v-model="sportAthleteTable.searchParam.birth_date" :placeholder="t('birthDatePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('photo')" prop="photo">
                        <el-input v-model="sportAthleteTable.searchParam.photo" :placeholder="t('photoPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('registrationType')" prop="registration_type">
                        <el-input v-model="sportAthleteTable.searchParam.registration_type" :placeholder="t('registrationTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('registrationTime')" prop="registration_time">
                        <el-input v-model="sportAthleteTable.searchParam.registration_time" :placeholder="t('registrationTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportAthleteTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportAthleteTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportAthleteTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportAthleteTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportAthleteTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportAthleteList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportAthleteTable.data" size="large" v-loading="sportAthleteTable.loading">
                    <template #empty>
                        <span>{{ !sportAthleteTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="event_id" :label="t('eventId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="team_id" :label="t('teamId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="gender" :label="t('gender')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="id_card" :label="t('idCard')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="phone" :label="t('phone')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="birth_date" :label="t('birthDate')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="photo" :label="t('photo')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="registration_type" :label="t('registrationType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="registration_time" :label="t('registrationTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportAthleteTable.page" v-model:page-size="sportAthleteTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportAthleteTable.total"
                        @size-change="loadSportAthleteList()" @current-change="loadSportAthleteList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportAthleteList, deleteSportAthlete } from '@/addon/sport/api/sport_athlete'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportAthleteTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "member_id":"",
      "event_id":"",
      "team_id":"",
      "name":"",
      "gender":"",
      "id_card":"",
      "phone":"",
      "birth_date":"",
      "photo":"",
      "registration_type":"",
      "registration_time":"",
      "sort":"",
      "status":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取参赛人员列表
 */
const loadSportAthleteList = (page: number = 1) => {
    sportAthleteTable.loading = true
    sportAthleteTable.page = page

    getSportAthleteList({
        page: sportAthleteTable.page,
        limit: sportAthleteTable.limit,
         ...sportAthleteTable.searchParam
    }).then(res => {
        sportAthleteTable.loading = false
        sportAthleteTable.data = res.data.data
        sportAthleteTable.total = res.data.total
    }).catch(() => {
        sportAthleteTable.loading = false
    })
}
loadSportAthleteList()

const router = useRouter()

/**
 * 添加参赛人员
 */
const addEvent = () => {
    router.push('/sport_athlete/sport_athlete_edit')
}

/**
 * 编辑参赛人员
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_athlete/sport_athlete_edit?id='+data.id)
}

/**
 * 删除参赛人员
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportAthleteDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportAthlete(id).then(() => {
            loadSportAthleteList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportAthleteList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
